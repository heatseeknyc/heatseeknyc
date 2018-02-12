module ApplicationHelper
  def convert_to_lisp_case(string)
    string.downcase.gsub(" ", "-")
  end

  def titlize(string)
    string.split.map {|w| w.capitalize}.join(" ")
  end

  def friendly_est_datetime(datetime)
    datetime.in_time_zone('Eastern Time (US & Canada)').strftime("%m/%d/%Y @ %I:%M%P %Z")
  end
end
