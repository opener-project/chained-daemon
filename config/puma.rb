APP_NAME     = 'opener'
deploy_to    = "/var/www/#{APP_NAME}"
run_path     = "/var/run/#{APP_NAME}"
log_path     = "/var/log/#{APP_NAME}"

threads 0,1

bind 'tcp://0.0.0.0:9292'
bind "unix://#{run_path}/chained-daemon-server.sock"

