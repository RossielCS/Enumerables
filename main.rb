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
end

[11, 79, 15, 43, 38, 1].my_each { |items| items * 2 }
