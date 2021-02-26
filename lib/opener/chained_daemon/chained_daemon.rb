module Opener
  class ChainedDaemon

    class_attribute :http
    self.http = HTTPClient.new
    self.http.send_timeout    = 600
    self.http.receive_timeout = 600
    self.http.connect_timeout = 600

    DEFAULT_OPTIONS = {
    }

    def initialize options = {}
      @options   = DEFAULT_OPTIONS.merge options
      @queue_map = {
        'opener-language-identifier':    Opener::LanguageIdentifier.new,
        'stanza-processor':              Stanza::Processor.new,
        'opener-property-tagger':        Opener::PropertyTagger.new,
        'opener-polarity-tagger':        Opener::PolarityTagger.new,
        'opener-opinion-detector-basic': Opener::OpinionDetectorBasic.new,
      }
    end

    def run input, _params = {}
      params = SymMash.new _params
      params.translate_languages ||= []
      params.cache_keys = SymMash.new params.cache_keys&.to_h&.sort&.to_h || {}
      if params.filter_vertical and params.property_type.present?
        params.cache_keys.property_type = params.property_type
      end
      params.cache_keys.environment ||= 'production'

      lang     = nil
      output   = nil
      @queue_map.each do |queue, component|
        debug_print queue, input if ENV['DEBUG']

        output = component.run input, params
        input  = output

      rescue Core::UnsupportedLanguageError
        xml  = Nokogiri.parse input
        lang = xml.root.attr('xml:lang')
        raise unless lang.in? params.translate_languages

        input = translate xml, params
        retry
      end

      if lang
        # put back original language
        xml    = Nokogiri.parse output
        xml.root.attributes['lang'].value = lang
        output = xml.to_s
      end

      output = pretty_print output if params.cache_keys.environment == 'staging'
      output

    rescue Core::UnsupportedLanguageError
      puts "Error on unsupported language: #{input}" if ENV['DEBUG']
      output
    end

    def pretty_print(output)
      doc = REXML::Document.new output
      doc.context[:attribute_quote] = :quote
      out = ""
      formatter = REXML::Formatters::Pretty.new
      formatter.compact = true
      formatter.write(doc, out)

      out.strip
    end

    def translate xml, params
      raw = xml.at :raw
      case translate_service params
      when :google
        raw.content = google_translator.translate raw.content, to: :en
      when :microsoft
        raw.content = microsoft_translator.translate raw.content, to: :en
      else
        raw.content = google_translator.translate raw.content, to: :en
      end

      xml.root.attributes['lang'].value = 'en'
      xml.to_s
    end

    protected

    def translate_service params
      params.translate_service&.to_sym || :google
    end

    def google_translator
      @google_translator ||= Google::Cloud.new.translate ENV['GOOGLE_TRANSLATE_TOKEN']
    end

    def microsoft_translator
      @microsoft_translator ||= MicrosoftTranslator.new
    end

    private

    def debug_print queue, input
      return unless ENV['DEBUG']
      File.write "input-#{queue}", input if ENV['DEBUG']
      puts input
    end

  end
end
