require 'timeout'

def euclidean_distance(c1, c2)
  Math.sqrt((c1[0] - c2[0])**2.0 + (c1[1] - c2[1])**2.0).round
end

def pick(n)
  (0..LENGTH-1).to_a.shuffle.first(n)
end

def cost(tour)
  (0.upto(tour.length - 2)).inject(0) do |total, i|
    total + euclidean_distance(tour[i], tour[i+1])
  end
end

# pick some nodes a,b,c,d and permute to a random order e.g. a,d,c,b
# return the tour represented with those changes.
def perturbation(tour)
  new_tour  = tour.clone
  nodes     = pick(6) # double bridge swap
  values    = nodes.map { |n| new_tour[n] }.shuffle

  nodes.each_with_index do |n, i|
    new_tour[n] = values[i]
  end

  new_tour
end

# keep attempting random single swaps until we don't get improvements
def local_search(tour, max_no_improv)
  best = { vector: tour, cost: cost(tour) }
  no_improv_count = 0

  while no_improv_count < max_no_improv
    swap_a, swap_b = pick(2)

    candidate = best[:vector].clone
    candidate[swap_a], candidate[swap_b] = candidate[swap_b], candidate[swap_a]
    candidate_cost = cost(candidate)

    if candidate_cost < best[:cost]
      best = { vector: candidate, cost: candidate_cost }
      no_improv_count = 0
    else
      no_improv_count += 1
    end
  end

  best
end

def search(tour, max_iterations, max_no_improv)
  best = { vector: tour, cost: cost(tour) }

  max_iterations.times do |i|
    candidate = local_search(
      perturbation(best[:vector]),
      max_no_improv
    )

    if candidate[:cost] < best[:cost]
      best = candidate
      puts "new best in iteration #{i}, current cost: #{best[:cost]}"
    end
  end

  best
end

if __FILE__ == $0
  # problem configuration. optimal tour is 7542
  berlin52 = [[565,575],[25,185],[345,750],[945,685],[845,655],
   [880,660],[25,230],[525,1000],[580,1175],[650,1130],[1605,620],
   [1220,580],[1465,200],[1530,5],[845,680],[725,370],[145,665],
   [415,635],[510,875],[560,365],[300,465],[520,585],[480,415],
   [835,625],[975,580],[1215,245],[1320,315],[1250,400],[660,180],
   [410,250],[420,555],[575,665],[1150,1160],[700,580],[685,595],
   [685,610],[770,610],[795,645],[720,635],[760,650],[475,960],
   [95,260],[875,920],[700,500],[555,815],[830,485],[1170,65],
   [830,610],[605,625],[595,360],[1340,725],[1740,245]]
  LENGTH = berlin52.length

  # algorithm configuration
  max_iterations  = 1000 # exhaustiveness of global search
  max_no_improv   = 50 # exhaustiveness of local search

  # execute the algorithm
  random_tour = berlin52.shuffle
  puts "Starting with cost #{cost(random_tour)}"

  Timeout.timeout(1200) do
    best = search(random_tour, max_iterations, max_no_improv)
    puts "Done. Best Solution: c=#{best[:cost]}"#, v=#{best[:vector].inspect}"
  rescue Timeout::Error
    puts "timed out. make me faster or don't try as hard"
  end
end
