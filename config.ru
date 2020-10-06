require 'bundler/setup'
require_relative 'lib/opener/chained_daemon'

run Opener::ChainedDaemon::Webservice.freeze.app

