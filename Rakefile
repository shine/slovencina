# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

=begin
require 'metric_fu'

MetricFu::Configuration.run do |config|
   config.metrics  = [:rcov, :saikuro, :stats, :flog, :flay]
   config.graphs   = [:rcov, :flog, :flay, :stats]
   config.rcov[:rcov_opts] << "-Itest" 
end
=end
