class HungryChart
  def self.pie(hash)
    total = hash.inject(0){|s, p| k,v = p; s += v.to_i}
    data = {:legend => [], :data => []}
    sorted = hash.sort_by{|k, v| v }
    sorted.each do |k, v|
      p = (total > 0) ? ((v.to_f/total) * 100).round : 0
      data[:data].push v
      data[:legend].push "#{k} (#{p}%)"
    end
    Gchart.pie_3d(
      :data =>    data[:data],
      :legend =>  data[:legend],
      :size =>    '750x250'
    )
  end
end
