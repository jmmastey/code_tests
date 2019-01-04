# following along with:
# http://www.thagomizer.com/blog/2017/09/13/ml-basics-k-nearest-neighbors.html
#
# KNN is lazy because it doesn't build a model until a prediction is needed.

require 'csv'

def euclidean_distance(p, q)
  raise ArgumentError unless p.length == q.length

  dists = 0.upto(p.length-1).map do |i|
    (p[i] - q[i]) ** 2
  end

  Math.sqrt(dists.inject(&:+))
end

# choosing a good K here is important. with 3 species in the dataset, I'm
# picking a k value that isn't divisible by 3 to reduce the possibility of ties,
# is relatively small so it grabs only close neighbors, but is large enough
# to have some significance. so, I guessed.
def predict(entry, data, k:)
  data.map { |point| [euclidean_distance(point[0..3], entry[0..3]), point[4]] }
      .sort_by(&:first)            # sort by closeness
      .first(k)                    # grab top n
      .group_by(&:last)            # group into varieties
      .max_by { |a| a[1].length }  # take biggest group
      .first                       # our winner!
end


new_iris = [5.0, 3.0, 4.4, 1.6, nil]
data = CSV.read("iris.data.txt", converters: :all ).to_a

puts predict(new_iris, data, k: 5)
