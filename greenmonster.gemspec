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
  s.description = %q{A utility for working with MLB Gameday XML data.}

  s.rubyforge_project = "greenmonster"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "nokogiri"
  s.add_dependency "httparty"
end
