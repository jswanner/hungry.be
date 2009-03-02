class HungryChart
  def self.pie(hash)
    data = {:legend => [], :data => []}
    sorted = hash.sort_by{|k, v| v }
    sorted.each do |k, v|
      data[:data].push v
      data[:legend].push k
    end
    Gchart.pie(
      :data =>    data[:data],
      :legend =>  data[:legend],
      :size =>    '600x400'
    )
  end
end
