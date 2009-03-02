class Vote < CouchRest::ExtendedDocument
  use_database CouchRest.database!('http://localhost:5984/hungry-be-dev')
  property :poll_id
  property :candidate
  timestamps!
end
