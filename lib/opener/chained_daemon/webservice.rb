require 'roda'

module Opener
  class ChainedDaemon
    class Webservice < Roda

      TOKEN = ENV['PRIVATE_TOKEN']

      route do |r|
        response.status = 403 and r.halt if r.params['auth_token'] != TOKEN

        r.get 'sentiment.kaf' do
          'Hello, world'
        end
      end

      def clear_cache
      end

    end
  end
end
