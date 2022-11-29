lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "omniauth-joinme/version"

Gem::Specification.new do |spec|
  spec.name = "omniauth-joinme"
  spec.version = OmniAuth::Joinme::VERSION
  spec.authors = ["Matt Agra"]
  spec.email = ["matt@docsend.com"]

  spec.summary = "An OmniAuth strategy for join.me"
  spec.description = "An OmniAuth strategy for join.me"
  spec.homepage = "https://github.com/docsend/omniauth-joinme"
  spec.license = "MIT"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "bug_tracker_uri" => "#{spec.homepage}/issues"
  }

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(bin|test|spec|features)/}) }
  spec.bindir = "exe"
  spec.executables = []
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "omniauth-oauth2", ">= 1.3.1"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "mocha", "~> 2.0"
end
