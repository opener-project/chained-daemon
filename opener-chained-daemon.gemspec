require_relative 'lib/opener/chained_daemon/version'

Gem::Specification.new do |spec|
  spec.name          = 'opener-chained-daemon'
  spec.version       = Opener::ChainedDaemon::VERSION
  spec.authors       = ['development@olery.com']
  spec.summary       = 'OpeNER daemon for processing multiple queues at once'
  spec.description   = spec.summary

  spec.license = 'Apache 2.0'

  spec.files = Dir.glob([
    'config/**/*',
    'lib/**/*',
    '*.gemspec',
    'README.md',
    'LICENSE.txt'
  ]).select { |file| File.file?(file) }

  spec.add_dependency 'activesupport'
  spec.add_dependency 'opener-daemons'
  spec.add_dependency 'opener-callback-handler', '~> 1.0'

  spec.add_dependency 'opener-language-identifier'
  spec.add_dependency 'opener-tokenizer'
  spec.add_dependency 'opener-pos-tagger'
  spec.add_dependency 'opener-polarity-tagger'
  spec.add_dependency 'opener-property-tagger'
  spec.add_dependency 'opener-ner'
  spec.add_dependency 'opener-opinion-detector-basic'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rack-test'
end
