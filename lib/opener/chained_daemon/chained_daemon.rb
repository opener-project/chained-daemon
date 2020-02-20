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
      @translator = Google::Cloud.new.translate ENV['GOOGLE_TRANSLATE_TOKEN']
    end

    def run input, params = {}
      params.symbolize_keys!
      params[:translate_languages] ||= []

      output   = nil
      @queue_map.each do |queue, component|
        debug_print queue, input if ENV['DEBUG']

        output = component.run input
        input  = output
      rescue Core::UnsupportedLanguageError
        xml  = Nokogiri.parse input
        lang = xml.root.attr('xml:lang')
        raise unless lang.in? params[:translate_languages]

        input  = translate input
        retry
      end
      output
    rescue Core::UnsupportedLanguageError
      puts "Error on unsupported language: #{input}" if ENV['DEBUG']
      output
    end

    def translate input
      xml = Nokogiri.parse input
      raw = xml.at :raw
      raw.content = @translator.translate raw.content, to: :en
      xml.root.attributes['lang'].value = 'en'
      xml.to_s
    end

    def debug_print queue, input
      return unless ENV['DEBUG']
      File.write "input-#{queue}", input if ENV['DEBUG']
      puts input
    end

  end
end
