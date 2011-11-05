class Category
  include DataMapper::Resource
  
  property :id,     Serial
  property :label,  String
  
  has n, :messages
end