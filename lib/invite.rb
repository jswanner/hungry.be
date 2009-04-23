class Invite < CouchRest::ExtendedDocument
  use_database CouchRest.new('http://localhost:5984').database!('hungry_be')
  
  property :poll_id
  property :contact_type
  property :contact_address
  timestamps!
end
