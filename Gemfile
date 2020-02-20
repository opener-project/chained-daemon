source 'https://rubygems.org'

def path_for p
  return unless ENV['LOCAL_GEMS']
  "../#{p}"
end

gem 'opener-language-identifier', path: path_for('language-identifier')
gem 'opener-daemons', path: path_for('daemons')

gemspec

