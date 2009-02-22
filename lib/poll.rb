class Poll
  attr_accessor :id

  def self.find(id)
    poll = new
    poll.id = id
    poll
  end
end
