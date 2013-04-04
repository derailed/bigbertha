require 'bundler'

Bundler.require

Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
  t.ruby_opts = "-W -I./spec -rspec_helper"
end

desc 'Cleanup build artifacts'
task :clean do
  FileUtils.rm_r( File.expand_path( File.join( %w(.. coverage) ), __FILE__ ) )
end

task default: :spec