if RAILS_ENV == "test"
  
  require 'cache_test'  
  ActionController::Base.perform_caching = true
  ActionController::Base.cache_store = :test_store  
  
end