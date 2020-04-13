module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    i = 0
    while i < length
      yield(self[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    while i < length
      yield(self[i], i)
      i += 1
    end
    self
  end
end

[11, 79, 15, 43, 38, 1].my_each { |items| puts items * 2 }

[27, 76, 48, 37, 24, 12, 47].my_each_with_index { |_x, y| puts y }
