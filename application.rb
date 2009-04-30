$:.unshift File.dirname(__FILE__) + '/lib'
Dir.glob(File.dirname(__FILE__) + '/vendor/**/lib').each do |dir|
  $:.unshift dir
end

%w(couchrest sinatra gchart pony poll vote invite chart).each do |lib|
  require lib
end

configure :development do
  set :domain, 'hungry.be.local'
  CouchRest::Document.database = CouchRest.new('http://localhost:5984').database!('hungry_be')
end

configure :production do
  set :domain, 'hungry.be'
  CouchRest::Document.database = CouchRest.new('http://localhost:5984').database!('hungry_be')
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

  def can_vote?(invite, poll_id)
    invite.poll_id == poll_id && !invite.has_voted
  end

  def can_invite?(poll_id)
    polls = get_polls_from_cookie
    polls.include?(poll_id)
  end
end

get '/' do
	haml :index
end

get '/new' do
  haml :new
end

get '/:poll_id' do
  poll = Poll.get params[:poll_id]
  haml :show, :locals => {:poll => poll}
end

get '/css/application.css' do
  response['Content-Type'] = 'text/css; charset=utf-8'
  sass :application
end

get '/:poll_id/invite' do
  haml :invite, :locals => {:poll_id => params[:poll_id]}
end

get '/:poll_id/:invite_id' do
  poll = Poll.get params[:poll_id]
  invite = Invite.get params[:invite_id]
  if can_vote?(invite, poll.id) 
    haml :vote, :locals => {:poll => poll, :invite => invite}
  else
    redirect "/#{poll.id}"
  end
end

post '/new' do
  poll = Poll.new params
  poll.save
  invite = Invite.new(:poll_id => poll.id)
  invite.save
  redirect "/#{poll.id}/#{invite.id}"
end

post '/:poll_id/invite' do
  poll_id = params[:poll_id]
  params[:addresses].each do |address|
    unless address.empty?
      invite = Invite.new(
        :address => address,
        :poll_id => poll_id
      )
      invite.save
    end
  end
  redirect "/#{poll_id}"
end

post '/:poll_id/:invite_id' do
  poll_id = params[:poll_id]
  invite = Invite.get params[:invite_id]
  if can_vote?(invite, poll_id)
    vote = Vote.new params
    vote.save
    poll = Poll.get poll_id
    poll.update_chart_url!
    add_poll_to_cookie(poll.id)
    invite.has_voted = true
    invite.save
  end
  redirect "/#{poll_id}"
end
