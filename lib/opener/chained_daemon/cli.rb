module Opener
  class ChainedDaemon
    ##
    # CLI wrapper around {Opener::ChainedDaemon} using Slop.
    #
    # @!attribute [r] parser
    #  @return [Slop]
    #
    class CLI

      attr_reader :parser

      def initialize
        @parser = configure_slop
      end

      ##
      # @param [Array] argv
      #
      def run argv = ARGV
        parser.parse argv
      end

      ##
      # @return [Slop]
      #
      def configure_slop
        Slop.new strict: false, indent: 2, help: true do
          banner 'Usage: chained-daemon [OPTIONS]'

          separator <<-EOF.chomp

About:


Example:

    cat some_file.kaf | chained-daemon
          EOF

          separator "\nOptions:\n"

          on :v, :version, 'Shows the current version' do
            abort "chained-daemon v#{VERSION} on #{RUBY_DESCRIPTION}"
          end

          run do |opts, args|
            daemon = ChainedDaemon.new args: args
            input  = STDIN.tty? ? nil : STDIN.read
            params = if ENV['PARAMS'] then JSON.parse ENV['PARAMS'] else {} end

            # Set environment as staging from console for testing purposes
            env = ENV['LEXICONS_ENV'] || 'staging'
            pt  = ENV['LEXICONS_PROPERTY_TYPE']
            params[:language]   = ENV['OVERRIDE_LANGUAGE']
            params[:cache_keys] = {
              environment:   env,
              property_type: pt,
              merged:        (true if env == 'staging'),
            }

            output = daemon.run input, params
            puts output
          end
        end
      end

    end
  end
end
