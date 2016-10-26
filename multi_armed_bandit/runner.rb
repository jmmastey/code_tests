require 'table_print'
require_relative 'lib/variant'
require_relative 'lib/multi_armed_bandit'
Dir["lib/strategies/*.rb"].each { |file| require_relative file }

# TODO: Look at how quickly we converge on p < 0.05 using a 2-tailed Z-test
# TODO: Add other strategies from https://en.wikipedia.org/wiki/Multi-armed_bandit#Bandit_strategies

variants = [
  Variant.new(name: "good", chance: 10),
  Variant.new(name: "bad", chance: 5) ]

MultiArmedBandit.new(
  runs: 10_000,
  variants: variants,
  strategy: EpsilonGreedyStrategy.new(name: "EpsilonGreedy(50)", epsilon: 50),
).run

MultiArmedBandit.new(
  runs: 10_000,
  variants: variants,
  strategy: EpsilonGreedyStrategy.new(name: "EpsilonGreedy(10)", epsilon: 10),
).run
