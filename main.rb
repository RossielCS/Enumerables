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

  def my_select
    return to_enum(:my_select) unless block_given?

    result = []
    my_each { |i| result << i if yield(i) }
    result
  end

  def my_all?(a = 0)
    unless block_given?
      if a.class == Class
        my_each { |x| return false unless x.is_a? a }
      elsif a.class == Regexp
        my_each { |x| return false unless a.match?(x.to_s) }
      elsif [nil, false].include?(a)
        my_each { |x| return false unless x == a }
      else
        return !empty?
      end
      return true
    end
    my_each { |i| return false unless yield(i) }
    true
  end

  def my_any?(a = 0)
    unless block_given?
      if a.class == Class
        my_each { |x| return true if x.is_a? a }
      elsif a.class == Regexp
        my_each { |x| return true if a.match?(x.to_s) }
      elsif [nil, false].include?(a)
        my_each { |x| return true if x == a }
      else
        return !empty?
      end
      return false
    end
    my_each { |i| return true if yield(i) }
    false
  end
end

# [11, 79, 15, 43, 38, 1].my_each { |items| puts items * 2 }

# [27, 76, 48, 37, 24, 12, 47].my_each_with_index { |_x, y| puts y }

# [6, 9, 47, 59, 86, 11, 30].my_select { |x| (x % 3).zero? }

# puts(%w[a abc hello names dialog telephone bo].my_all? { |x| x.length >= 1 })

# print [3, 2i, 5.6].my_all?(String)

# print([nil, 55, 'hi'].my_any?{ |x| x.is_a? Numeric })
