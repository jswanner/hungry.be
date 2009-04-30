Dir.glob(File.dirname(__FILE__) + '/vendor/sinatra*/lib').each do |dir|
  $:.unshift dir
end
require 'sinatra'
require 'application'
set :run, false
set :environment, ENV['RACK_ENV'].to_sym
run Sinatra::Application


