require 'rubygems'
require 'sinatra'
require 'lib/poll'

get '/' do
	haml :index
end

get '/new' do
  haml :new
end

get '/:id' do
  poll = Poll.find(params[:id])
  haml :show, :locals => {:poll => poll}
end

post '/new' do
  redirect '/asdf'
end

get '/css/application.css' do
  header 'Content-Type' => 'text/css; charset=utf-8'
  sass :application
end
