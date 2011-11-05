@baseAdminPath = "/admin"

get "#{@baseAdminPath}" do
  "Default admin view"
end

get "#{@baseAdminPath}/categories" do
  "Categories list"
end

post "#{@baseAdminPath}/category" do
  "Create a new category"
  redirect "#{@baseAdminPath}/categories"
end

get "#{@baseAdminPath}/category/:id" do 
  "View a category #{params[:id]} and list messages"
end

post "#{@baseAdminPath}/category/:id" do 
  "Edit a category #{params[:id]}"
  redirect "#{@baseAdminPath}/category/#{params[:id]}"
end

post "#{@baseAdminPath}/category/:id/message" do 
  "Create a new message for category #{params[:id]}"
  redirect "#{@baseAdminPath}/category/#{params[:id]}"
end

get "#{@baseAdminPath}/message/:id" do 
  "View a message #{params[:id]}"
end

post "#{@baseAdminPath}/message/:id" do 
  "Edit a message #{params[:id]}"
  redirect "#{@baseAdminPath}/message/#{params[:id]}"
end

delete "#{@baseAdminPath}/category/:id" do
  "Delete a category of id #{params[:id]}"
  redirect "#{@baseAdminPath}/categories"
end

delete "#{@baseAdminPath}/message/:idm" do 
  "Delete a message #{params[:idm]}"
  redirect "#{@baseAdminPath}/category/#{message.category}"
end

