module MathHelpers
  def self.mean(arr)
    arr.inject(&:+) / arr.length
  end

  def self.mean_variance(arr)
    mean_result = MathHelpers.mean(arr)
    arr.inject(0.0) do |total_variance, elem|
      total_variance + ((elem - mean_result) ** 2)
    end / arr.length
  end
end
