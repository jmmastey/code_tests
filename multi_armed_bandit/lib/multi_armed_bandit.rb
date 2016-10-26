class MultiArmedBandit
  def initialize(variants:, runs: 1000, strategy: EpsilonGreedyStrategy.new)
    @variants   = variants
    @runs       = runs
    @batch_size = 100
    @p          = 0
    @strategy   = strategy
  end

  def run
    @variants.map(&:reset)
    (1..@runs).each_slice(@batch_size) do |items|
      items.length.times { create_hit }
      @p += items.length
      # show
    end
    show
  end

  def create_hit
    chosen = @strategy.choose_variant(@variants)
    chosen.hit!
  end

  def total_conversion
    (@variants.inject(0) { |sum, v| sum + v.successes } /
     @variants.inject(0) { |sum, v| sum + v.hits      }.to_f) * 100
  end

  def show
    puts "Scoring after #{@p} runs with #{@strategy.name}:"
    tp @variants, :name, :hits, :successes, :perf
    puts "Total test conversion: %02.2f\%" % total_conversion
    puts ""
  end
end
