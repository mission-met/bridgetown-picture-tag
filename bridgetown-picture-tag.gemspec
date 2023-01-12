# frozen_string_literal: true

require_relative "lib/bridgetown-picture-tag/version"

Gem::Specification.new do |spec|
  spec.name          = "bridgetown-picture-tag"
  spec.version       = BridgetownPictureTag::VERSION
  spec.author        = "Ricky Chilcott"
  spec.email         = "ricky@missionmet.com"
  spec.summary       = "Plugin to build a picture tag and transform images for Bridgetown"
  spec.homepage      = "https://github.com/mission-met/bridgetown-picture-tag"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r!^(test|script|spec|features|frontend)/!) }
  spec.test_files    = spec.files.grep(%r!^spec/!)
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.7.0"

  spec.add_dependency "bridgetown", ">= 1.2.0.beta4", "< 2.0"

  spec.add_dependency "ruby-vips", ">= 2.1.0"
  spec.add_dependency "image_processing", ">= 1.11.3"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop-bridgetown", "~> 0.2"
  spec.add_development_dependency "capybara"
end