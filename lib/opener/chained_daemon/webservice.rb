require 'roda'

module Opener
  class ChainedDaemon
    class Webservice < Roda

      TOKEN = ENV['PRIVATE_TOKEN']

      class_attribute :processor
      self.processor = ChainedDaemon.new

      route do |r|
        response.status = 403 and r.halt if r.params['auth_token'] != TOKEN

        sentiment = -> do
          r.params.deep_symbolize_keys!
          kaf = processor.run r.params[:input], **r.params.except(:input)

          response['Content-Type'] = 'text/xml'
          kaf
        end

        r.get  'sentiment.kaf', &sentiment
        r.post 'sentiment.kaf', &sentiment
      end

      def clear_cache
      end

    end
  end
end
