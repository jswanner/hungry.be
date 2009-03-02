require 'rubygems'
require 'sinatra'

root_dir = File.dirname(__FILE__)

Sinatra::Application.set(
  :views    => File.join(root_dir, 'views'),
  :app_file => File.join(root_dir, 'application.rb'),
  :run => false,
  :environment => ENV['RACK_ENV'].to_sym
)

run Sinatra::Application

