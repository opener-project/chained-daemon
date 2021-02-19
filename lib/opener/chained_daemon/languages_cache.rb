module Opener
  class ChainedDaemon
    class LanguagesCache

      include MonitorMixin

      UPDATE_INTERVAL = (ENV['CACHE_EXPIRE_MINS']&.to_i || 5).minutes

      def initialize
        super #MonitorMixin

        @url          = ENV['SUPPORTED_LANGUAGES_URL']
        @cache        = []
        @last_updated = nil
      end

      def get
        synchronize do
          break @cache if @last_updated and @last_updated > UPDATE_INTERVAL.ago
          cache_update
        end
      end

      def cache_update
        puts "loading supported languages from url #{@url}" if ENV['DEBUG']

        languages     = SymMash.new JSON.parse http.get(@url).body
        @last_updated = Time.now
        @cache        = languages.data.each.with_object({}){ |l,h| h[l.code] = l }
        @cache
      end

      def http
        return @http if @http

        @http = HTTPClient.new
        @http.send_timeout    = 120
        @http.receive_timeout = 120
        @http.connect_timeout = 120
        @http
      end

    end
  end
end
