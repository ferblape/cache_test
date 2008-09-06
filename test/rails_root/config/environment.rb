# Specifies gem version of Rails to use when vendor/rails is not present
old_verbose, $VERBOSE = $VERBOSE, nil
RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION
$VERBOSE = old_verbose

require File.join(File.dirname(__FILE__), 'boot')

require 'active_support'
require RAILS_ROOT + '/../../lib/cache_test'

Rails::Initializer.run do |config|
  config.log_level = :debug
  config.cache_classes = false
  config.whiny_nils = true
  config.action_controller.perform_caching = true
  config.cache_store = :test_store
end
 
# Dependencies.log_activity = true
