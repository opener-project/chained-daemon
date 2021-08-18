require_relative 'term'

module Opener
  module KAF
    class Document

      attr_reader :document
      attr_reader :lexicons

      attr_accessor :map

      def initialize xml
        @document = xml
      end

      def self.from_xml xml
        new Nokogiri::XML xml
      end

      def language
        @language ||= @document.at_xpath('KAF').attr 'xml:lang'
      end

      def terms
        @terms ||= collection 'KAF/terms/term', Term
      end

      def texts
        @texts ||= collection 'KAF/texts/wf', Text
      end

      def raw
        @document.at('raw').text
      end

      def add_linguistic_processor name, version, layer, timestamp: false
        header  = @document.at('kafHeader') || @document.root.add_child('<kafHeader/>').first
        procs   = header.css('linguisticProcessors').find{ |l| l.attr(:layer) == layer }
        procs ||= header.add_child("<linguisticProcessors layer='#{layer}'/>").first
        lp      = procs.add_child('<lp/>')
        lp.attr(
          timestamp: if timestamp then Time.now.iso8601 else '*' end,
          version:   version,
          name:      name,
        )
        lp
      end

      def add_word_form params
        text = @document.at('text') || @document.root.add_child('<text/>').first
        wf   = text.add_child("<wf>#{params.text}</wf>")
        attrs = {
          wid:    "w#{params.wid}",
          sent:   params.sid,
          para:   params.para,
          offset: params.offset,
          length: params.length,
          head:   params.head,
          xpos:   params.xpos
        }
        wf.attr attrs
      end

      def add_term params
        text  = @document.at('terms') || @document.root.add_child('<terms/>').first
        term  = text.add_child("<term/>")
        attrs = {
          tid:        "t#{params.tid}",
          type:       params.type,
          lemma:      params.lemma,
          text:       params.text,
          pos:        params.pos,
          morphofeat: params.morphofeat,
          head:       params.head,
          xpos:       params.xpos
        }
        term.attr attrs
        term.first.add_child("<span><target id='w#{params.wid}'/></span>")
      end

      def to_xml
        @document.to_xml indent: 2
      end

      protected

      def collection query, wrapper
        @document.xpath(query).map{ |node| wrapper.new self, node }
      end

    end
  end
end
