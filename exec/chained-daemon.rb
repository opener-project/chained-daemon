#!/usr/bin/env ruby

require 'opener/daemons'

require_relative '../lib/opener/chained_daemon'

daemon = Opener::Daemons::Daemon.new Opener::ChainedDaemon
daemon.start
