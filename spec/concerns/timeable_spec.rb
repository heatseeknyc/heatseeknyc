require 'spec_helper'
include Timeable::InstanceMethods

describe Timeable do
  it 'can make a pretty date' do
    datetime = DateTime.new(2014,1,2)
    expect(pretty_date(datetime)).to eq("Jan 2, 2014")
  end

  it 'can make a pretty time' do
    time = Time.new(2002, 10, 31, 2, 2, 2)
    expect(pretty_time(time)).to eq("2:02 AM")
  end

  it 'can check if an hour is in the daytime' do
    hour = 8
    expect(day_time_hours_include?(hour)).to be true
  end

  it 'can check if an hour is in the nighttime' do
    hour = 5
    expect(night_time_hours_include?(hour)).to be true
  end

  it 'can check that a datetime\'s hour is in the daytime' do
    datetime = DateTime.new(2014,1,2,8,2,2)
    expect(day_time_hours_include?(datetime.hour)).to be true
  end
end