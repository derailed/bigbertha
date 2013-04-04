# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "firewater/version"

Gem::Specification.new do |s|
  s.name        = "firewater"
  s.version     = Firewater::VERSION
  s.platform    = Gem::Platform::RUBY

  s.authors     = [
    "Fernand Galiana"
  ]

  s.email             = ["fernand.galiana@gmail.com"]
  s.homepage          = "https://github.com/derailed/firewater"
  s.summary           = %q{Ruby implementation of Firebase framework}
  s.description       = %q{Ruby implementation of Firebase framework}
  s.rubyforge_project = "firebase"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'map'     , '~> 6.3.0'
  s.add_dependency 'typhoeus', '~> 0.6.2'
end