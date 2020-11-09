require 'active_support/all'
require 'oga'
require 'hashie'
require 'google/cloud/translate'

require 'opener/daemons'

require_relative 'chained_daemon/languages_cache'
require 'opener/language_identifier'
require 'opener/tokenizer'
require 'opener/pos_tagger' if RUBY_ENGINE == 'jruby'
require 'opener/polarity_tagger'
require 'opener/property_tagger'
require 'opener/opinion_detector_basic'
require 'opener/stanza/tokenizer_pos'

require_relative 'chained_daemon/chained_daemon'
require_relative 'chained_daemon/cli'
require_relative 'chained_daemon/microsoft_translator'
require_relative 'chained_daemon/webservice'

require_relative 'kaf/document'
require_relative 'kaf/term'

