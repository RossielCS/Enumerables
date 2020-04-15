module Enumerable
  UNDEFINED = Object.new

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

  def my_select
    return to_enum(:my_select) unless block_given?

    result = []
    my_each { |i| result << i if yield(i) }
    result
  end

  def my_all?(arg = UNDEFINED)
    unless block_given?
      my_each { |x| return false unless x.is_a? arg } if arg.is_a? Class
      my_each { |x| return false unless arg.match?(x.to_s) } if arg.class == Regexp
      my_each { |x| return false unless x == arg } if arg == UNDEFINED
      return true
    end
    my_each { |i| return false unless yield(i) }
    true
  end

  def my_any?(arg = UNDEFINED)
    unless block_given?
      my_each { |x| return true if x.is_a? arg } if arg.is_a? Class
      my_each { |x| return true if arg.match?(x.to_s) } if arg.class == Regexp
      my_each { |x| return true if x } if arg == UNDEFINED
      return false
    end
    my_each { |i| return true if yield(i) }
    false
  end

  def my_none?(arg = UNDEFINED)
    unless block_given?
      my_each { |x| return false if x.is_a? arg } if arg.is_a? Class
      my_each { |x| return false if arg.match?(x.to_s) } if arg.class == Regexp
      my_each { |x| return false if x } if arg == UNDEFINED
      return true
    end
    my_each { |i| return false if yield(i) }
    true
  end

  def my_count(arg = UNDEFINED)
    count = 0
    unless block_given?
      if arg
        my_each { |x| count += 1 if x == arg }
        return count
      end
      return arg.length
    end
    my_each { |i| count += 1 if yield(i) }
    count
  end

  def my_map
    result = []
    to_a.my_each_with_index { |_, y| result << yield(to_a[y]) }
    result
  end

  def my_inject(arg = UNDEFINED)
    new_arr = to_a
    accumulator = new_arr.shift
    unless arg == UNDEFINED
      accumulator = arg
      to_a.my_each { |x| accumulator = yield(accumulator, x) }
      return accumulator
    end
    new_arr.my_each { |x| accumulator = yield(accumulator, x) }
    accumulator
  end

  def multiply_els
    my_inject { |x, y| x * y }
  end
end

# [11, 79, 15, 43, 38, 1].my_each { |items| puts items * 2 }

# [27, 76, 48, 37, 24, 12, 47].my_each_with_index { |_x, y| puts y }

# [6, 9, 47, 59, 86, 11, 30].my_select { |x| (x % 3).zero? }

# puts(%w[a abc hello names dialog telephone bo].my_all? { |x| x.length >= 1 })

# print [3, 2i, 5.6].my_all?(String)

# print([nil, 55, 'hi'].my_any?{ |x| x.is_a? Numeric })

# [nil, false, true].my_none?

# [1, 2, 4, 2].count{ |x| x.even? }

# print((1..4).my_map { |x| x * x })

# (5..10).my_inject(2) { |product, n| product * n }
