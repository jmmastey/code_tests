require_relative '../lib/math_helpers'
require 'table_print'
require 'benchmark'

class StochasticSearch
  attr_reader :space, :fitness, :sample

  def initialize(space:, fitness:, sample: nil)
    @space    = space
    @fitness  = fitness
    @sample   = sample || ->(space) { rand(space) }
  end

  def search(iterations: space.length / 2)
    best = [ nil, (-1 * Float::INFINITY) ]

    iterations.times do
      candidate = sample.call(space)
      score     = fitness.call(candidate)

      if score > best.last
        best = [ candidate, score ]
      end
    end

    best.first
  end
end

# test execution

# this has terrible performance for trying to find a goal at the extremes
#goal    = 50_000_000_000_000
goal    = 500_000
search  = StochasticSearch.new(
  space: (0..100_000_000_000_000),
  fitness: ->(n) { (n - goal).abs * -1 },
)

res = [10, 100, 1000, 10000, 100000].map do |n|
  guesses   = nil
  time    = Benchmark.realtime {
    guesses = 100.times.map { search.search(iterations: n) }
  }
  pct_error = guesses.map { |g| (100 - ((g / goal.to_f) * 100)).abs }

  {
    iterations: n,
    time: time.round(5),
    mean: MathHelpers.mean(guesses),
    mean_pct_err: MathHelpers.mean(pct_error).round(3),
  }
end

tp res
