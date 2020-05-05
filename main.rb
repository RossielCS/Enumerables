module Enumerable
  UNDEFINED = Object.new

  def my_each
    return to_enum(:my_each) unless block_given?

    arr = to_a
    i = 0
    while i < arr.length
      yield(arr[i])
      i += 1
    end
    arr
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    arr = to_a
    i = 0
    while i < arr.length
      yield(arr[i], i)
      i += 1
    end
    arr
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

  def my_any?(arg = UNDEFINED, &block)
    unless block_given?
      if arg != UNDEFINED
        my_each { |x| return true if arg === x }
      else
        my_each { |x| return true if x }
      end
      return false
    end
    my_each { |i| return true if block.call(i) }
    false
  end

  def my_none?(arg = UNDEFINED, &block)
    !my_any?(arg, &block)
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

  def my_map(my_proc = UNDEFINED)
    return to_enum(:my_map) unless block_given?

    result = []
    arr = to_a
    if my_proc == UNDEFINED
      arr.my_each_with_index { |_, y| result << yield(arr[y]) }
    else
      arr.my_each_with_index { |_, y| result << my_proc.call(arr[y]) }
    end
    result
  end

  def my_inject(*arg)
    new_arr = to_a
    accumulator = arg[0]
    if arg[0].class == Symbol
      accumulator = new_arr[0]
      new_arr = new_arr[1..-1]
      new_arr.my_each { |x| accumulator = accumulator.send(arg[0], x) }
    elsif arg[0].class < Numeric && arg[1].class != Symbol
      new_arr.my_each { |x| accumulator = yield(accumulator, x) }
    elsif arg[0].class < Numeric && arg[1].class == Symbol
      new_arr.my_each { |x| accumulator = accumulator.send(arg[1], x) }
    else
      accumulator = new_arr[0]
      new_arr = new_arr[1..-1]
      new_arr.my_each { |x| accumulator = yield(accumulator, x) }
    end
    accumulator
  end
end

def multiply_els(arg)
  arg.my_inject(:*)
end
