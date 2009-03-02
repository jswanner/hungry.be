class Poll < CouchRest::ExtendedDocument
  use_database CouchRest.database!('http://localhost:5984/hungry-be-dev')
  property :chart_url
  property :candidates, :default => []
  timestamps!


  create_callback :after do |poll|
    update_chart_url
    save
  end

  save_callback :before , :update_chart_url

  def update_chart_url
    self.chart_url = HungryChart.pie(votes)
  end

  def update_chart_url!
    update_chart_url
    save
  end

  private

  def votes
    @votes = candidates.inject({}){|h, c| h[c] = 0; h}
    view = database.view('test/candidate-count', :group => true, :key => self.id)["rows"][0]
    view['value'].each{ |k, v| @votes[k] = v } if view['value']
    @votes
  end
end
