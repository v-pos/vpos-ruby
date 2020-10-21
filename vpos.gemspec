lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vpos/version"

Gem::Specification.new do |spec|
  spec.name          = "vpos"
  spec.version       = Vpos::VERSION
  spec.authors       = ["Sergio Maziano"]
  spec.email         = ["sergio@nextbss.co.ao"]

  spec.summary       = %q{The one stop shop for online payments in Angola.}
  spec.description   = %q{The one stop shop for online payments in Angola. This gem allows you process payments requests from EMIS GPO through vPOS.}
  spec.homepage      = "https://github.com/nextbss/vpos-ruby"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "httparty", "~> 0.18.1"
  spec.add_dependency "rspec", "~> 3.9.0"
end
