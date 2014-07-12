require 'pry'
require 'net/http'

switch = true

while switch do

  sofar = open('sofar.txt', 'r')
  current_reading = sofar.readlines[0].to_i
  sofar.close

  readings = open('readings.txt', 'r').readlines
  uri = URI('http://heatseeknyc.com/readings')

  readings.each do |reading|
    sensor_name, temp, time, verification = reading.split(',')
    response = Net::HTTP.post(uri, "sensor_name=#{sensor_name}&temp=#{temp}&time=#{time}&verification=#{verification}")
    sleep(1)

    binding.pry
  end


end


# curl -X POST -H "Content-Type: application/json" -d '{"reading": {"sensor_name": "tahiti", "temp": "56", "time": "Wed Jul  2 16:07:09 EDT 2014", "verification": "1234"}}' localhost:3000/readings.json