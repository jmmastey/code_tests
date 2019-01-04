# checking the accuracy of the KNN algorithm from the other file against the
# existing dataset.

require 'csv'

def euclidean_distance(p, q)
  raise ArgumentError unless p.length == q.length

  dists = 0.upto(p.length-1).map do |i|
    (p[i] - q[i]) ** 2
  end

  Math.sqrt(dists.inject(&:+))
end

def predict(entry, data, k:)
  data.map { |point| [euclidean_distance(point[0..3], entry[0..3]), point[4]] }
      .sort_by(&:first)            # sort by closeness
      .first(k)                    # grab top n
      .group_by(&:last)            # group into varieties
      .max_by { |a| a[1].length }  # take biggest group
      .first                       # our winner!
end

def accuracy_for_k_value(data, k:)
  ((data.count do |e|
    remaining_data = data - [e]
    e[4] == predict(e, remaining_data, k: k)
  end / data.length.to_f) * 100).round(3)
end


data = CSV.read("iris.data.txt", converters: :all ).to_a
k = 4

1.upto(100) do |k|
  puts "#{accuracy_for_k_value(data, k: k)} correct for #{k}"
end
