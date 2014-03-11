class TwineController < ApplicationController
  def index
    twine = Twine.find_by(name: "twine1")
    @chart_hash = twine.chart_hash
    @range = twine.range
  end
end
