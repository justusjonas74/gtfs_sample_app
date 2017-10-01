# config valid only for current version of Capistrano
lock '3.9.1'

set :application, 'fahrplan'
set :repo_url, 'git@github.com:justusjonas74/gtfs_sample_app.git'
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :user, 'deploy'
server 'app.francisdoege.com', user: "#{fetch(:user)}", roles: %w{app db web}, primary: true
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :pty, true

set :rvm_ruby_version, '2.4.1'

append :linked_files, 'config/database.yml', 'config/secrets.yml', 'config/puma.rb'
append :linked_dirs, 'log', 'public/.well-known', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads'



set :config_example_suffix, '.example'
set :config_files, %w{config/database.yml config/secrets.yml}
set :puma_conf, "#{shared_path}/config/puma.rb"

set :nginx_domains, "app.francisdoege.com www.app.francisdoege.com"
set :nginx_use_ssl, true
set :nginx_ssl_certificate, 'fullchain.pem'
# SSL certificate file path
# default value: "/etc/ssl/certs"
set :nginx_ssl_certificate_path, "/etc/letsencrypt/live/app.francisdoege.com/"

# Name of SSL certificate private key
# default value: "#{application}.key"
set :nginx_ssl_certificate_key, 'privkey.pem'

# SSL certificate private key path
# default value: "/etc/ssl/private"
set :nginx_ssl_certificate_key_path, "/etc/letsencrypt/live/app.francisdoege.com/"


namespace :deploy do
  before 'check:linked_files', 'config:push'
  before 'check:linked_files', 'puma:jungle:setup'
  before 'check:linked_files', 'puma:nginx_config'
  after 'puma:smart_restart', 'nginx:restart'
end
