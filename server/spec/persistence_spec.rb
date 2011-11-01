require File.join(File.dirname(__FILE__), '..', 'lib/libs_helper')
require File.join(File.dirname(__FILE__), 'json_helper')

describe "Persistence layer" do
  before(:all) do                                                                                                                                                           
    DataMapper.setup(:default, 'sqlite::memory:')                                                                                                                           
                                                                                                                                                                            
    DataMapper.finalize                                                                                                                                                     
    DataMapper.auto_upgrade!                                                                                                                                                
  end
  
  it "should create a new Category" do
    Category.all.count.should eq(0)
    
    cat1 = Category.new
    cat1.should_not be_nil
    cat1.label = "My first category"
    cat1.save
    
    Category.all.count.should eq(1)
  end
  
  it "should not be possible to create a Message without a Category" do
    Message.all.count.should eq(0)
    message = Message.new(
      :content  => "Mon message qui ne verra pas le jour"
    )
    message.save.should be_false
    Message.all.count.should eq(0)
  end
  
  it "should add others Categories for testing" do
    Category.all.count.should eq(1)
    Category.create(
      :label => "mysecond category"
    )
    Category.create(
      :label => "mythird category"
    )
    Category.create(
      :label => "mythird category"
    )
    Category.all.count.should eq(4)
  end
  
  it "should be possible to create a Message with a Category" do
    category = Category.all[0]
    category.should_not be_nil
    category.label.should eq "My first category"
    
    Message.all.count.should eq(0)
    category.messages.count.should eq(0)
    Message.create(
      :content  => "Merci madame, monsieur de bien vouloir etre cool",
      :category => category
    )
    Message.all.count.should eq(1)
    category.messages.count.should eq(1)
  end
  
  it "should be possible to add a Message to a Category" do
    category = Category.all[1]
    category.should_not be_nil
    
    Message.all.count.should eq(1)
    message = Message.create(
      :content => "C'est avec un grand regret que tu dois nous quitter ce soir..."
    )
    
    Message.all.count.should eq(1)
    category.messages.push(message).save.should be_true
    Message.all.count.should eq(2)
  end
  
  it "should be possible to create an Annoucement" do
    Announce.all.count.should eq(0)
    Announce.create(
      :content => "Pensez a voter pour notre super application"
    )
    Announce.all.count.should eq(1)
  end
  
  describe "after serializing into JSON" do
    it "should have an expected Announce" do
      announce = Announce.all[0]
      announce.should_not be_nil
      announce.content.should eq("Pensez a voter pour notre super application")
      
      check_announce(JSON.parse(announce.to_json))
    end
    
    it "should have an expected Categories" do
      categories = Category.all
      check_categories(JSON.parse(categories.to_json))
    end
    
    it "should have an expected Message" do
      message = Message.all[0]
      check_message(JSON.parse(message.to_json))
    end
  end
end