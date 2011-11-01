require "rubygems"
require "sinatra"
require "json"

messages = ["Mon premier texte de bienvenu", "Mon deuxieme texte un peu funny", "Mon troisieme texte ou l'on se marre"]

get "/v1/categories" do
  content_type 'application/json', :charset => 'utf-8'
  
  categories = []
  categories.push({"id" => "cat1", "label" => "Category 1"})
  categories.push({"id" => "cat2", "label" => "Category 2"})
  categories.push({"id" => "cat3", "label" => "Category 3"})
  categories.to_json
end

get "/v1/categories/:category/random" do |category|
  content_type 'application/json', :charset => 'utf-8'
  {
    "content"  => "#{category}: " + messages[rand(messages.size)],
    "category" => "#{category}",
    "id"       => "id1"
  }.to_json
end

get "/v1/announce" do
  content_type 'application/json', :charset => 'utf-8'
  {
    "content" => "Do not forget to give your feedback !",
    "id" => "pub1-demo"
  }.to_json
end