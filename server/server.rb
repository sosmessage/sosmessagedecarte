require "rubygems"
require "sinatra"
require "json"

messages = ["Mon premier texte de bienvenu", "Mon deuxieme texte un peu funny", "Mon troisieme texte ou l'on se marre"]

get "/v1/messages" do
  ["message" => messages[rand(3)]].to_json
end