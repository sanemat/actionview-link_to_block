# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'action_view/link_to_block/version'

Gem::Specification.new do |spec|
  spec.name          = "actionview-link_to_block"
  spec.version       = ActionView::LinkToBlock::VERSION
  spec.authors       = ["sanemat"]
  spec.email         = ["o.gata.ken@gmail.com"]
  spec.description   = %q{Link to with block}
  spec.summary       = %q{Link to with block}
  spec.homepage      = "https://github.com/sanemat/actionview-link_to_block"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", '>= 1.3'
  spec.add_development_dependency "rake"
end
