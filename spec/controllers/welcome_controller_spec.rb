require 'spec_helper'

describe WelcomeController do

  describe "GET 'index'" do
    it "returns the splash page" do
      get 'index'
      response.should include("NYC")
    end
  end

end
