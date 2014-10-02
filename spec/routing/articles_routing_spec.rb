require "spec_helper"

describe ArticlesController do
  describe "routing" do

    it "routes to #index" do
      get("/articles").should route_to("articles#index")
    end

    it "routes to #new" do
      get("/articles/new").should route_to("articles#new")
    end

    it "routes to #show" do
      get("/articles/1").should route_to("articles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/articles/1/edit").should route_to("articles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/articles").should route_to("articles#create")
    end

    it "routes to #update" do
      put("/articles/1").should route_to("articles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/articles/1").should route_to("articles#destroy", :id => "1")
    end

  end
end
