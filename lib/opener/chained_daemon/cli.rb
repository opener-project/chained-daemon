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

            puts daemon.run input
          end
        end
      end

    end
  end
end
