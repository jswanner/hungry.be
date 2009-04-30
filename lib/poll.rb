class Poll < CouchRest::ExtendedDocument
  property :chart_url
  property :candidates, :default => []
  timestamps!

  create_callback :after, :update_chart_url!
  save_callback :before, :remove_empty_candidates
  save_callback :before, :update_chart_url

  view_by :votes,
    :map =>
      "function(doc) {
        if(doc['couchrest-type'] == 'Vote' && doc['candidate']) {
          emit(doc['poll_id'], doc['candidate']);
        }
      }",
    :reduce =>
      "function(keys, values, rereduce) {
        if(!rereduce){
          var result = {};
          values.forEach(function(node){
            if(result[node]){
              result[node]++;
            }else{
              result[node] = 1;
            }
          });
          return result;
        }else{
          var result = {};
          values.forEach(function(node){
            for(prop in node){
              if(result[prop]){
                result[prop] += node[prop];
              }else{
                result[prop] = node[prop];
              }
            }
          });
          return result;
        }
      }"

  def update_chart_url
    self.chart_url = HungryChart.pie(votes)
  end

  def update_chart_url!
    update_chart_url
    save
  end

  private
  
  def remove_empty_candidates
    self['candidates'].delete_if {|c| c.empty? }
  end

  def votes
    @votes = candidates.inject({}){|h, c| h[c] = 0; h}
    view = Poll.by_votes(:reduce => true, :group => true, :key => self.id)["rows"][0]
    view['value'].each{ |k, v| @votes[k] = v } if view
    @votes
  end
end
