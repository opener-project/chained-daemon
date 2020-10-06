require 'roda'

module Opener
  class ChainedDaemon
    class Webservice < Roda

      TOKEN = ENV['PRIVATE_TOKEN']

      class_attribute :processor
      self.processor = ChainedDaemon.new

      route do |r|
        response.status = 403 and r.halt if r.params['auth_token'] != TOKEN

        r.get 'sentiment.kaf' do
          params = r.params.except 'input'
          params.deep_symbolize_keys!
          kaf    = processor.run r.params['input'], **params

          response['Content-Type'] = 'text/xml'
          kaf
        end
      end

      def clear_cache
      end

    end
  end
end
