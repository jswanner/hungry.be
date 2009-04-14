require 'rubygems'
# Demo app built for 0.9.x
gem 'sinatra', '~> 0.9'
require 'application'
set :run, false
set :environment, ENV['RACK_ENV'].to_sym
run Sinatra::Application


