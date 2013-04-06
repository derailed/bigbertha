# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "basilik/version"

Gem::Specification.new do |s|
  s.name        = "basilik"
  s.version     = Basilik::VERSION
  s.platform    = Gem::Platform::RUBY

  s.authors     = [
    "Fernand Galiana"
  ]

  s.email             = ["fernand.galiana@gmail.com"]
  s.homepage          = "https://github.com/derailed/basilik"
  s.summary           = %q{Ruby implementation for your Firebase batteries}
  s.description       = "Firebase is a real time backend to allow clients to share" +
                        "data on the web. This gem provides a ruby API implementation."
  s.rubyforge_project = "basilik"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'map'     , '~> 6.3.0'
  s.add_dependency 'typhoeus', '~> 0.6.2'
end