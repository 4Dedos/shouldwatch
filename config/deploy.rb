$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
require "bundler/capistrano"
set :rvm_ruby_string, 'ruby-1.9.2-p290@shouldwatch'
set :rvm_type, :user

set :application, "Should Watch"
set :repository,  "git@github.com:4Dedos/shouldwatch.git"
set :branch, "master"
set :deploy_via, :copy
set :copy_exclude, [".git"]
set :use_sudo, false


set :deploy_to, "/home/deploy/apps/shouldwatch.com"

set :user, "deploy"
default_run_options[:pty] = true

set :scm, :git

role :web, "shouldwatch.com"
role :app, "shouldwatch.com"
role :db,  "shouldwatch.com", :primary => true


namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
namespace :db do
  desc "[internal] Updates the symlink for database.yml file to the just deployed release"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
end

after "deploy:finalize_update", "db:symlink" 