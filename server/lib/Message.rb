require 'json'

class Message
  include DataMapper::Resource
  
  property :id,         Serial
  property :content,    Text
  
  belongs_to :category
  
  def to_json
    {
      "id"        => self.id,
      "content"   => self.content,
      "category"  => self.category.id
    }.to_json
  end
end