$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'rubygems'
%w(jchris-couchrest mattetti-googlecharts).each do |gh_gem|
  gem gh_gem
end
%w(sinatra couchrest gchart poll vote chart).each do |gem|
  require gem
end

configure :development do
  set :domain, 'hungry.be.local'
end

configure :production do
  set :domain, 'hungry.be'
end

helpers do
  def add_poll_to_cookie(poll_id)
    polls = get_polls_from_cookie
    polls << poll_id
    response.set_cookie("polls", {
      :domain => options.domain,
      :path => '/',
      :expires => Time.now + (60 * 60 * 24 * 365),
      :value => polls
    })
  end

  def get_polls_from_cookie
    cookie = request.cookies["polls"]
    cookie ||= ""
    polls = cookie.split('&')
  end

  def can_vote?(poll_id)
    polls = get_polls_from_cookie
    !polls.include?(poll_id)
  end
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
  poll_id = params[:poll_id]
  if can_vote?(poll_id)
    vote = Vote.new params
    vote.save
    poll = Poll.get poll_id
    poll.update_chart_url!
    add_poll_to_cookie(poll.id)
  end
  redirect "/#{poll_id}"
end

get '/css/application.css' do
  response['Content-Type'] = 'text/css; charset=utf-8'
  sass :application
end
