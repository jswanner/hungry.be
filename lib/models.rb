class Poll
  attr_accessor :id

  def self.find(id)
    post = new
    post.id = id
  end
end
