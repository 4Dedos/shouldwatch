$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) 
require "rvm/capistrano"                  
require "bundler/capistrano"
set :rvm_ruby_string, 'ruby-1.9.2-p290@shouldwatch'

set :application, "Should Watch"
set :repository,  "git@github.com:rallyonrails/2011-equipo-36.git"
set :branch, "master"
set :deploy_via, :copy
set :copy_exclude, [".git"]
set :use_sudo, false


set :deploy_to, "/home/deploy/apps/shouldwatch.com"

set :user, "deploy"  
default_run_options[:pty] = true  

set :scm, :git

role :web, "65.39.226.129"
role :app, "65.39.226.129"
role :db,  "65.39.226.129"


