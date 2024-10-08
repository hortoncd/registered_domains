
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "registered_domains/version"

Gem::Specification.new do |spec|
  spec.name          = "registered_domains"
  spec.version       = RegisteredDomains::VERSION
  spec.authors       = ["Chris Horton"]
  spec.email         = ["hortoncd@gmail.com"]

  spec.summary       = %q{Query domain registrars for your registered domains.}
  spec.homepage      = "https://github.com/hortoncd/registered_domains"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "> 1.17"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.8.0"
  spec.add_development_dependency "simplecov"#, "> 1.17"
  spec.add_development_dependency "webmock", "~> 3.5.1"
  spec.add_dependency "httparty", "~> 0.21"
  spec.add_dependency "namecheap-api", "= 0.0.1"
  spec.add_dependency "nokogiri", ">= 1.11", "< 1.17"
  spec.add_dependency "rexml", "~> 3.3.3"
end
