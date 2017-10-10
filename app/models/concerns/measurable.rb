module Measurable
  module ClassMethods

    def define_measureable_methods(metrics, cycles, measurements)
      metric_cycle_measures(metrics, cycles, measurements)  
      reading_nested_arrays(measurements)
      measurement_nested_arrays(measurements)
      measurement_hashes(measurements)
      measurement_methods(measurements)
    end
    
    def metric_cycle_measures(metrics, cycles, measurements)
      metrics.each do |metric|
        cycles.each do |cycle|
          measurements.each do |measurement|
            define_method("#{metric}_#{cycle}_#{measurement}") do 
              array = self.send("get_cycle_#{measurement}s", cycle)
              self.send(metric, array)
            end
          end
        end
      end
    end

    def reading_nested_arrays(measurements)
      define_method("reading_nested_array") do 
        readings.pluck(:created_at, *measurements).compact
      end

      define_method("reverse_reading_nested_array") do |_readings|
        _readings.order(created_at: :desc).pluck(:created_at, *measurements).compact
      end
    end

    def measurement_nested_arrays(measurements)
      measurements.each do |measurement|
        define_method("#{measurement}_nested_array") do 
          readings.pluck(:created_at, measurement).compact
        end
      end
    end

    def measurement_hashes(measurements)
      measurements.each do |measurement|
        define_method("#{measurement}_hash") do 
          send("#{measurement}_nested_array").each_with_object({}) do |pair, hsh| 
            key, value = *pair
            hsh[key] = value
          end
        end
      end
    end

    def measurement_methods(measurements)
      measurements.each do |measurement|
        define_method("#{measurement}s") do 
          readings.pluck(measurement).compact
        end
      end
    end
  end
  
  module InstanceMethods
    def avg(array)
      return nil if array.empty?
      array.sum / array.size
    end

    def max(array)
      array.max
    end

    def min(array)
      array.min
    end

    def get_cycle_temps(cycle)
      temp_array = []
      self.temp_nested_array.each do |time, temp|
        hour = time.hour + time_offset_in_hours
        temp_array << temp if self.send("#{cycle}_time_hours_include?", hour)
      end
      temp_array
    end

    def get_cycle_outdoor_temps(cycle)
      outdoor_temp_array = []
      self.outdoor_temp_nested_array.each do |time, temp|
        hour = time.hour + time_offset_in_hours
        outdoor_temps << temp if self.send("#{cycle}_time_hours_include?", hour)
      end
      outdoor_temp_array
    end

    def get_cycle_metric(cycle, measurement)
      array = []
      self.send("#{measurement}_nested_array").each do |time, measure|
        hour = time.hour + time_offset_in_hours
        array << temp if self.send("#{cycle}_time_hours_include?", hour)
      end
      array
    end
  end
  
  # def self.included(receiver)
  #   receiver.extend         ClassMethods
  #   receiver.send :include, InstanceMethods
  # end
end
