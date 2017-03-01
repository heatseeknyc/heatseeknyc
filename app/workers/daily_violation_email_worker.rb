class DailyViolationEmailWorker
  def initialize(start_at:, end_at:)
    @start_at = start_at
    @end_at = end_at
  end

  def perform
    results = violations_periods_query.to_a
    results.each { |r| r["user_id"] = r["user_id"].to_i }
    results.sort_by! { |r| [r["user_id"], r["start_at"]] }

    results_by_user = results.group_by { |violation| violation["user_id"] }
    advocate_ids = Collaboration.where(collaborator_id: results_by_user.keys).pluck(:user_id).uniq

    User.where(id: advocate_ids).find_each do |advocate|
      next if advocate.permissions > User::PERMISSIONS[:lawyer]

      tenants = advocate.collaborators.where(id: results_by_user.keys)

      violations = results.select { |r| tenants.map(&:id).include?(r["user_id"]) }
          .map { |r| ViolationEmailEntry.new(r, tenants.detect { |t| t.id == r["user_id"] }) }

      if Rails.env.test? ||
          ENV["FEATURE_VIOLATIONS_REPORT"] ||
          ENV["FEATURE_VIOLATIONS_REPORT_IDS"].split(" ").map(&:to_i).include?(advocate.id)
        UserMailer.violations_report(recipient: advocate, violations: violations)
      end
    end
  end

  def violations_periods_query
    query = <<-SQL
      SELECT 
        user_id,
        MAX(created_at) AS end_at,
        MIN(created_at) AS start_at,
        MAX(created_at)-MIN(created_at) AS duration

      FROM (
        WITH readings_day AS (
          SELECT *
          FROM readings
          WHERE created_at >= '#{@start_at.to_s}'
            AND created_at < '#{@end_at.to_s}'
        )
        SELECT *,
        (
          SELECT COUNT(*)
          FROM readings_day r2
          WHERE readings_day.violation <> r2.violation
            AND r2.created_at <= readings_day.created_at
            AND r2.user_id = readings_day.user_id
        ) AS group_num
        FROM readings_day 
        WHERE violation = true
      ) results

      WHERE true
      GROUP BY user_id, group_num
      HAVING MAX(created_at) - MIN(created_at) >= '2:59:00'::interval
      ORDER BY user_id;
    SQL

    ActiveRecord::Base.connection.execute(query)
  end

  ViolationEmailEntry = Struct.new(:data, :user)
end
