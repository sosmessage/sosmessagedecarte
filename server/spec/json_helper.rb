def check_categories(response)
  response.count.should > 0
  check_category(response[0])
end

def check_category(response)
  response.has_key?("id").should be_true
  response.has_key?("label").should be_true
end

def check_announce(response)
  response.has_key?("id").should be_true
  response.has_key?("content").should be_true
end

def check_message(response)
  response.has_key?("id").should be_true
  response.has_key?("content").should be_true
  response.has_key?("category").should be_true
end