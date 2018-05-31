module Opener
  class ChainedDaemon

    QUEUES_MAP = {
      'opener-language-identifier':    Opener::LanguageIdentifier,
      'opener-tokenizer':              Opener::Tokenizer,
      'opener-pos-tagger':             Opener::POSTagger,
      'opener-polarity-tagger':        Opener::PolarityTagger,
      'opener-property-tagger':        Opener::PropertyTagger,
      'opener-ner':                    Opener::Ner,
      'opener-opinion-detector-basic': Opener::OpinionDetectorBasic,
    }

    DEFAULT_OPTIONS = {
    }

    def initialize options = {}
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def run input
      QUEUES_MAP.each do |queue, klass|
        puts input
        input = klass.new.run input
      end
      puts input
    end

  end
end
