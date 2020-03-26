module Opener
  class ChainedDaemon
    class MicrosoftTranslator

      URL   = 'https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=%{to}'
      TOKEN = ENV['MICROSOFT_TRANSLATE_TOKEN']

      def initialize
        @http = HTTPClient.new
      end

      def translate text, to: :en
        url  = URL % {to: to}
        resp = @http.post url,
          body:   [{Text: text}].to_json,
          header: {'Ocp-Apim-Subscription-Key' => TOKEN, 'Content-Type' => 'application/json'}

        data = JSON.parse resp.body
        raise data['error']['message'] if data.is_a? Hash and data['error']

        data = Hashie::Mash.new data[0]
        data&.translations&.first&.text
      end

    end
  end
end
