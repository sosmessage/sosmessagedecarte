require "rubygems"
require "sinatra"
require "json"

messages = ["Mon premier texte de bienvenu", "Mon deuxieme texte un peu funny", "Mon troisieme texte ou l'on se marre"]

get "/v1/messages" do
  response = {"message" => messages[rand(messages.size)]}
  if (rand(2) % 2 == 0) 
    response["announce"] = {"content" => "Do not forget to give your feedback !"}
  end
  response.to_json
end