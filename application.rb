require 'rubygems'
require 'sinatra'

get '/' do
	haml :index
end

get '/new' do
  haml :new
end

post '/new' do
  redirect '/'
end

get '/:id' do
  haml :show
end

get '/css/application.css' do
  header 'Content-Type' => 'text/css; charset=utf-8'
  sass :application
end
