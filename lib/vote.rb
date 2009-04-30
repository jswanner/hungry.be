class Vote < CouchRest::ExtendedDocument
  property :poll_id
  property :candidate
  timestamps!
end
