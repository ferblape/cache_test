require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

# Test::Unit::UI::VERBOSE
test_files_pattern = 'test/{unit,functional,other}/**/*_test.rb'
Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = test_files_pattern
  t.verbose = false
end

Rake::RDocTask.new { |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = "Cache Test -- Some helpers for testing fragment/action cache"
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.template = "#{ENV['template']}.rb" if ENV['template']
  # rdoc.rdoc_files.include('README.rdoc', 'CONTRIBUTION_GUIDELINES.rdoc', 'lib/**/*.rb')
}

desc "Run code-coverage analysis using rcov"
task :coverage do
  rm_rf "coverage"
  files = Dir[test_files_pattern]
  system "rcov --rails --sort coverage -Ilib #{files.join(' ')}"
end

desc 'Default: run tests.'
task :default => ['test']

Dir['tasks/*.rake'].each do |f|
  load f
end

