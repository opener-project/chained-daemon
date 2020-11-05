module Opener
  module KAF
    class WordForm
      def initialize(document, xml_node)
        @document = document
        @xml_node = xml_node
      end

      def id
        return @id ||= @xml_node.attr('wid')
      end

      def text
        return @text ||= @xml_node.text
      end

      def length
        return @length ||= @xml_node.attr('length').to_i
      end

      def offset
        return @offset ||= @xml_node.attr('offset').to_i
      end

      def paragraph
        return @paragraph ||= @xml_node.attr('para').to_i
      end
    end
  end
end
