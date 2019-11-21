module Opener
  class ChainedDaemon

    DEFAULT_OPTIONS = {
    }

    def initialize options = {}
      @options   = DEFAULT_OPTIONS.merge options
      @queue_map = {
      'opener-language-identifier':    Opener::LanguageIdentifier.new,
      'opener-tokenizer':              Opener::Tokenizer.new,
      'opener-pos-tagger':             Opener::POSTagger.new,
      'opener-polarity-tagger':        Opener::PolarityTagger.new,
      'opener-property-tagger':        Opener::PropertyTagger.new,
      'opener-ner':                    Opener::Ner.new,
      'opener-opinion-detector-basic': Opener::OpinionDetectorBasic.new,
    }
    end

    def run input
      output = nil
      @queue_map.each do |queue, component|
        File.write "input-#{queue}", input if ENV['DEBUG']
        output = component.run input
        input  = output
      end
      output
    rescue Core::UnsupportedLanguageError
      puts "Error on unsupported language: #{input}" if ENV['DEBUG']
      output
    end
  end
end
