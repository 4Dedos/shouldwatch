$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, 'ruby-1.9.2-p290'        # Or whatever env you want it to run in.

set :application, "Should Watch"
set :repository,  "git@github.com:rallyonrails/2011-equipo-36.git"
set :branch, "master"
set :deploy_via, :remote_cache
set :use_sudo, false


set :deploy_to, "/home/deploy/apps/shouldwatch.com"

set :user, "deploy"  # The server's user for deploys
default_run_options[:pty] = true  # Must be set for the password prompt from git to work

set :scm, :git

role :web, "65.39.226.129"
role :app, "65.39.226.129"
role :db,  "65.39.226.129"


# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end