require 'bundler/setup'
require_relative 'lib/opener/chained_daemon'
require "rack-timeout"

use Rack::Timeout, service_timeout: 60

run Opener::ChainedDaemon::Webservice.freeze.app

