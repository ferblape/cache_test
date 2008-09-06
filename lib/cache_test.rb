require 'cache_test/test_store'
include ActiveSupport::Cache

require 'cache_test/fragment_cache_test'

Test::Unit::TestCase.class_eval do
  include CacheTest::Assertions
end

