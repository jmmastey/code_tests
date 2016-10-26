class EpsilonGreedyStrategy
  attr_accessor :name, :epsilon

  def initialize(name: "EpsilonGreedy", epsilon: 10)
    @name     = name
    @epsilon  = epsilon
  end

  def choose_variant(variants)
    if exploring?
      variants.sample
    else
      variants.sort_by(&:expectation).last
    end
  end

  def exploring?
    rand(1..100) <= epsilon
  end
end
