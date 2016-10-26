class Variant
  attr_accessor :name, :chance, :hits, :successes

  def initialize(name:, chance:)
    raise ArgumentError unless (0..100).include?(chance)
    @name       = name
    @chance     = chance
    @hits       = 0
    @successes  = 0
  end

  def hit!
    @hits += 1
    @successes += 1 if (rand(0..100) <= @chance)
  end

  def expectation
    return 0 if hits == 0

    (successes / hits.to_f) * 100
  end

  def perf
    "%02.2f\%" % expectation
  end

  def reset
    @hits       = 0
    @successes  = 0
  end
end
