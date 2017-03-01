class DailyViolationEmailWorker
  def initialize(start_at:, end_at:)
    @start_at = start_at
    @end_at = end_at
  end

  def perform
    violations_periods
  end

  private

  def violations_periods
    query = <<-SQL
      SELECT 
        user_id,
        MAX(created_at) AS end_at,
        MIN(created_at) AS start_at,
        MAX(created_at)-MIN(created_at) AS duration

      FROM (WITH readings_day AS (SELECT * FROM readings WHERE created_at >= '2017-02-11 21:00' AND created_at < '2017-02-13') SELECT *, (SELECT COUNT(*) FROM readings_day r2 WHERE readings_day.violation <> r2.violation AND r2.created_at <= readings_day.created_at AND r2.user_id = readings_day.user_id) AS group_num FROM readings_day WHERE violation = true) results WHERE true GROUP BY user_id, group_num HAVING MAX(created_at) - MIN(created_at) >= '3:00:00'::interval ORDER BY user_id;
    SQL

    ActiveRecord::Base.connection.execute(query)
  end
end
