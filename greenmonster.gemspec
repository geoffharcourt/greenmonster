# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "greenmonster/version"

Gem::Specification.new do |s|
  s.name        = "greenmonster"
  s.version     = Greenmonster::VERSION
  s.authors     = ["Geoff Harcourt"]
  s.email       = ["geoff.harcourt@gmail.com"]
  s.homepage    = "http://github.com/geoffharcourt/greenmonster"
  s.summary     = %q{A utility for working with MLB Gameday XML data.}
  s.description = %q{Greenmonster downloads XML data so that you can locally work with Gameday data for sabermetric research.}
  s.licenses    = ["MIT"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "httparty", "~> 0.14"
  s.add_dependency "nokogiri", "~> 1.6"

  s.add_development_dependency "rake", "~> 10.4"
  s.add_development_dependency "rspec", "~> 3.2"
  s.add_development_dependency "webmock", "~> 1.3"
  s.add_development_dependency "vcr", "~> 2.9"
end
