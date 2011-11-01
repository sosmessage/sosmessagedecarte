require File.dirname(__FILE__) + '/spec_helper'

describe "SOS Message server" do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end
  
  it "should return 404 when page cannot be found" do
    get '/v1'
    last_response.status.should == 404
  end
  
  it "should return a correct table of category when requesting categories" do
    get '/v1/categories'
    last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
    
    response = JSON.parse(last_response.body)
    response.count.should > 0
    
    category = response[0]
    category.has_key?("id").should be_true
    category.has_key?("label").should be_true
    category.has_key?("content").should be_false
  end
  
  it "should return a correct json content when requestion announce" do
    get '/v1/announce'
    last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
    
    response = JSON.parse(last_response.body)
    response.has_key?("id").should be_true
    response.has_key?("content").should be_true
    response.has_key?("label").should be_false
  end
  
  it "should return a correct json content when requestion a specific category" do
    get '/v1/categories/test/random'
    last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
    
    response = JSON.parse(last_response.body)
    response.has_key?("id").should be_true
    response.has_key?("category").should be_true
    response["category"].should eq("test")
    response.has_key?("content").should be_true
    response.has_key?("label").should be_false
  end
end