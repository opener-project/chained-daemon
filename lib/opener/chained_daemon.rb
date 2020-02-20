require 'active_support/all'
require 'oga'
require 'google/cloud/translate'

require 'opener/daemons'

require 'opener/language_identifier'
require 'opener/tokenizer'
# require ner before pos_tagger for compatible opennlp
require 'opener/ner'
require 'opener/pos_tagger'
require 'opener/polarity_tagger'
require 'opener/property_tagger'
require 'opener/opinion_detector_basic'

require_relative 'chained_daemon/chained_daemon'
require_relative 'chained_daemon/cli'
