require 'active_support/all'
require 'opener/daemons'

require 'opener/language_identifier'
require 'opener/tokenizer'
require 'opener/pos_tagger'
require 'opener/polarity_tagger'
require 'opener/property_tagger'
require 'opener/ner'
require 'opener/opinion_detector_basic'

require_relative 'chained_daemon/chained_daemon'
require_relative 'chained_daemon/cli'
