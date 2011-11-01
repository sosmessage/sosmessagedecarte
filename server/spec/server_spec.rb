require File.join(File.dirname(__FILE__), 'spec_helper')
require File.join(File.dirname(__FILE__), 'json_helper')

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
    
    check_categories(JSON.parse(last_response.body))
  end
  
  it "should return a correct json content when requestion announce" do
    get '/v1/announce'
    last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
    
    check_announce(JSON.parse(last_response.body))
  end
  
  it "should return a correct json content when requestion a specific category" do
    get '/v1/categories/test/random'
    last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
    
    check_message(JSON.parse(last_response.body))
  end
end