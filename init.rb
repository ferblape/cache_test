if RAILS_ENV == "test"
  
  require 'cache_test'  
  include CacheTest
  ActionController::Base.perform_caching = true
  ActionController::Base.cache_store = :test_store  
  
end