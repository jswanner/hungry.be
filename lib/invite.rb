class Invite < CouchRest::ExtendedDocument
  property :poll_id
  property :address
  property :has_voted, :default => false
  property :sent, :default => false
  timestamps!

  create_callback :before, :send_email

  view_by :poll,
    :map =>
      "function(doc) {
       if(doc['couchrest-type'] == 'Invite') {
          emit(doc['poll_id'], null);
        }
      }" 

  def send_email
    puts "sending mail to #{self.address}"
    Pony.mail(
      :to       => self.address,
      :subject  => 'hungry.be invitation',
      :body     => 'hello, world',
      :domain   => 'hungry.be',
      :via      => :sendmail,
    )
    self.sent = true
  end
end
