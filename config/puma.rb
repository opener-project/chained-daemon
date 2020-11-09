APP_NAME     = 'opener'
deploy_to    = "/var/www/#{APP_NAME}"
run_path     = "/var/run/#{APP_NAME}"
log_path     = "/var/log/#{APP_NAME}"

workers    ENV['WORKERS']&.to_i || 1  unless RUBY_ENGINE == 'jruby'
threads 0, ENV['THREADS']&.to_i || 16

bind 'tcp://0.0.0.0:9292'
#bind "unix://#{run_path}/chained-daemon-server.sock"

