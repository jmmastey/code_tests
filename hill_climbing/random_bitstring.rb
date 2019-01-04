def random_bitstring(size)
  Array.new(size) { [0, 0, 1].sample }
end

def inverse(v)
  v == 1 ? 0 : 1
end

# Random Mutation Hill Climbing
# each generation, one mutation is created. grows relatively slowly, but seems
# to do a better job with this problem set of creating a maximum score. I wonder
# to what extent a more complicated scoring function would need a different
# algorithm.
def mutate_rmhc(array)
  mutated_position = rand(array.length)

  array.clone.tap do |new_array|
    new_array[mutated_position] = inverse(new_array[mutated_position])
  end
end

# ES(1+1, m, hc)
# each cell has an equal (defined) probability of being changed for any
# given generation. interesting that for this problem set, it's hard to get to
# the global optimum solution with this strategy. as we get close, even with a
# large number of iterations, we tend to take as many steps backward as forward.
def mutate_es11(array, probability: 0.2)
  new_array = array.clone
  0.upto(new_array.length) do |i|
    new_array[i] = inverse(new_array[i]) if rand() < probability
  end
  new_array
end

def score(candidate)
  candidate.inject(&:+)
end

SIZE = 64
MAX_ITERATIONS = 10000

leader  = random_bitstring(SIZE)
score   = score(leader)

MAX_ITERATIONS.times do
  candidate = mutate_es11(leader)
  candidate_score = score(candidate)
  if(candidate_score > score)
    puts "found better candidate #{candidate_score}"

    leader = candidate
    score = candidate_score
  end
end

puts "winner w/ score #{score(leader)}:"
puts leader.join('')
