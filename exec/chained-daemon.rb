#!/usr/bin/env ruby

require 'opener/daemons'

require_relative '../lib/opener/chained_daemon'

webservice = Rack::Server.new app: Opener::ChainedDaemon::Webservice.freeze.app
Thread.new{ webservice.start }

daemon = Opener::Daemons::Daemon.new Opener::ChainedDaemon
daemon.start
