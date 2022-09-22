source 'https://rubygems.org'

gemspec

def path_for p
  return unless ENV['LOCAL_GEMS']
  "../#{p}"
end

gem 'opener-daemons', path: path_for('daemons')

gem 'opener-language-identifier',    path: path_for('language-identifier')
gem 'opener-property-tagger',        path: path_for('property-tagger')
gem 'opener-polarity-tagger',        path: path_for('polarity-tagger')
gem 'opener-opinion-detector-basic', path: path_for('opinion-detector-basic')

group :development do
  gem 'shotgun'
end
