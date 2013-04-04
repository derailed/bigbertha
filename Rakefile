require 'bundler'

Bundler.require

Bundler::GemHelper.install_tasks

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
  t.ruby_opts = "-I./spec"
end

desc 'Cleanup build artifacts'
task :clean do
  FileUtils.rm_r( File.expand_path( File.join( %w(.. coverage) ), __FILE__ ) )
end

task default: :spec