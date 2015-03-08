module ApplicationHelper
  def convert_to_lisp_case(string)
    string.downcase.gsub(" ", "-")
  end

  def titlize(string)
    string.split.map {|w| w.capitalize}.join(" ")
  end
end
