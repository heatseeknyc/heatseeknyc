require 'spec_helper'

describe Observation do
  describe ".new_from_hash" do
    it "returns an Observation" do
      response = {
        'date' => {
          'hour' => '07'
        },
        'tempi' => '45.8'
      }
      o = Observation.new_from_hash(response)
      expect(o.temperature).to eq 45.8
    end
  end
end
