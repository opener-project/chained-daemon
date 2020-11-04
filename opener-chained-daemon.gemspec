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
    'exec/**/*',
    'lib/**/*',
    '*.gemspec',
    'README.md',
    'LICENSE.txt'
  ]).select{ |file| File.file? file }

  spec.bindir = 'bin'
  spec.executables = Dir.glob('bin/*').map{ |file| File.basename(file) }

  spec.add_dependency 'activesupport'
  spec.add_dependency 'google-cloud-translate', '~> 1.0'
  spec.add_dependency 'httpclient'
  spec.add_dependency 'hashie'

  spec.add_dependency 'roda'
  spec.add_dependency 'rack-timeout'
  spec.add_dependency 'faraday'
  spec.add_dependency 'opener-daemons', '~> 2.7.1'
  spec.add_dependency 'opener-callback-handler', '~> 1.0'

  spec.add_dependency 'opener-language-identifier', '>= 4.4.0'
  spec.add_dependency 'opener-tokenizer',  '>= 2.2.0'
  spec.add_dependency 'opener-pos-tagger', '>= 3.2.0'
  spec.add_dependency 'opener-polarity-tagger', '>= 3.2.5'
  spec.add_dependency 'opener-property-tagger', '>= 3.3.3'
  spec.add_dependency 'opener-opinion-detector-basic', '>= 3.2.1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rack-test'
end
