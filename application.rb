require 'rubygems'
%w(jchris-couchrest mattetti-googlecharts).each do |gh_gem|
  gem gh_gem
end
%w(sinatra couchrest gchart lib/poll lib/vote lib/chart).each do |gem|
  require gem
end

get '/' do
	haml :index
end

get '/new' do
  haml :new
end

get '/:id' do 
  poll = Poll.get params[:id]
  haml :show, :locals => {:poll => poll}
end

get '/:id/vote' do
  poll = Poll.get params[:id]
  haml :vote, :locals => {:poll => poll}
end

post '/new' do
  poll = Poll.new params
  poll.save
  redirect "/#{poll.id}"
end

post '/:poll_id/vote' do
  vote = Vote.new params
  vote.save
  poll = Poll.get params[:poll_id]
  poll.update_chart_url!
  redirect "/#{poll.id}"
end

get '/css/application.css' do
  response['Content-Type'] = 'text/css; charset=utf-8'
  sass :application
end
