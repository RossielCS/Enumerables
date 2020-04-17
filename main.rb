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
      if arg != UNDEFINED
        my_each { |x| return false unless arg === x }
      else
        my_each { |x| return false unless x }
      end
      return true
    end
    my_each { |i| return false unless yield(i) }
    true
  end

  def my_any?(arg = UNDEFINED)
    unless block_given?
      if arg != UNDEFINED
        my_each { |x| return true if arg === x }
      else
        my_each { |x| return true if x }
      end
      return false
    end
    my_each { |i| return true if yield(i) }
    false
  end

  def my_none?(arg = UNDEFINED)
    unless block_given?
      if arg != UNDEFINED
        my_each { |x| return false if arg === x }
      else
        my_each { |x| return false if x }
      end
      return true
    end
    my_each { |i| return false if yield(i) }
    true
  end

  def my_count(arg = UNDEFINED)
    count = 0
    unless block_given?
      if arg != UNDEFINED
        my_each { |x| count += 1 if x == arg }
        return count
      end
      return length
    end
    my_each { |i| count += 1 if yield(i) }
    count
  end

  def my_map
    return to_enum(:my_map) unless block_given?

    result = []
    to_a.my_each_with_index { |_, y| result << yield(to_a[y]) }
    result
  end

  def my_inject(*arg)
    accumulator = arg[0]
    if arg[0].class == Symbol
      new_arr = to_a
      accumulator = new_arr.shift
      new_arr.my_each { |x| accumulator = accumulator.send(arg[0], x) }
    elsif arg[0].class < Numeric && arg[1].class != Symbol
      to_a.my_each { |x| accumulator = yield(accumulator, x) }
    elsif arg[0].class < Numeric && arg[1].class == Symbol
      to_a.my_each { |x| accumulator = accumulator.send(arg[1], x) }
    else
      accumulator = to_a.shift
      to_a.my_each { |x| accumulator = yield(accumulator, x) }
    end
    accumulator
  end

  def multiply_els
    my_inject(:*)
  end
end
