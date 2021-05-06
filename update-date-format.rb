require 'csv'
require 'pry'

csv = CSV.read("/Users/bolandrm/Desktop/feather0327.csv", headers: true)

csv.each do |row|
  time = DateTime.parse(row["time"]).to_time.to_i
  puts "#{time},#{row['temperature']},#{row['humidity']}"
end