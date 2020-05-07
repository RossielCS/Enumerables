require_relative '../main'

describe Enumerable do
  let(:array) { [1, 2, 3, 4, 5, 6] }
  let(:array_boolean) { [true, true, nil, false, true, true] }
  let(:array_false) { [nil, false] }
  let(:range) { (1..6) }
  let(:string) { 'a string' }
  let(:process) { proc { |n| n + 2 } }
  let(:array_string) { [ 'a', 's', 't', 'r', 'i', 'n', 'g' ] }

  describe '#my_each' do
    it 'returns an enumerator if the block is not given' do
      expect(array.my_each).to be_an_instance_of(Enumerator)
    end

    it 'returns the element if the block is given' do
      expect(array.my_each { |x| x * 2 }).to eql(array)
    end
  end

  describe '#my_each_with_index' do
    it 'returns an enumerator if the block is not given' do
      expect(array.my_each_with_index).to be_an_instance_of(Enumerator)
    end

    it 'returns the element if the block is given' do
      expect(array.my_each_with_index { |x, _| x * 2 }).to eql(array)
    end
  end

  describe '#my_select' do
    it 'returns an enumerator if no block is given' do
      expect(array.my_select).to be_an_instance_of(Enumerator)
    end

    it 'returns an array with the items that match yield pattern' do
      expect(array.my_select(&:even?)).to eql([2, 4, 6])
    end
  end

  describe '#my_all?' do
    it 'unless block_given, returns true if all items are true' do
      expect(array.my_all?).to eql(true)
    end

    it 'doesn\'t returns true if an item is false or nil' do
      expect(array_boolean.my_all?).not_to eql(true)
    end

    it 'when block is given, it returns true if all cases are true' do
      expect(array.my_all? { |m| m.is_a? Integer }).to eql(true)
    end

    it 'when block is given, it doesn\'t return true if at least one case is false' do
      expect(array.my_all? { |m| m > 1 }).not_to eql(true)
    end

    it 'when block is given, it returns true if all cases are true in a range' do
      expect(range.my_all? { |m| m.is_a? Integer }).to eql(true)
    end

    it 'return true when an argument is given and all the cases are true' do
      expect(range.my_all?(Integer)).to eql(true)
    end

    it 'doesn\'t return true when an argument is given and at least one case is false' do
      expect(array_boolean.my_all?(true)).not_to eql(true)
    end

    it 'return true when a RegExp is given and all the cases are true' do
      expect(array_string.my_all?(/[a-z]/)).to eql(true)
    end
  end

  describe '#my_any?' do
    it 'returns true if one of the elements is true' do
      expect(array_boolean.my_any?).to eql(true)
    end

    it 'doesn\'t returns true if none of the elements is true' do
      expect(array_false.my_any?).not_to eql(true)
    end

    it 'returns true if the block given ever returns true' do
      expect(array.my_any? { |x| x == 5 }).to eql(true)
    end

    it 'doesn\'t returns true if the block given never returns true' do
      expect(range.my_any? { |x| x == 8 }).not_to eql(true)
    end

    it 'returns true if pattern === element is true for an element' do
      expect(array_boolean.my_any?(nil)).to eql(true)
    end

    it 'doesn\'t returns true if pattern === element is false for all elements' do
      expect(array_false.my_any?(Integer)).not_to eql(true)
    end

    it 'return true when an argument is given and at least one case is true' do
      expect(range.my_any?(2)).to eql(true)
    end

    it 'doesn\'t return true when an argument is given and any case is true' do
      expect(array_boolean.my_any?(Integer)).not_to eql(true)
    end

    it 'return true when a RegExp and at least one case is true' do
      expect(array_string.my_any?(/[a-c]/)).to eql(true)
    end
  end

  describe '#my_none?' do
    it 'returns true if all the elements are false' do
      expect(array_false.my_none?).to eql(true)
    end

    it 'doesn\'t returns true if all the elements are true' do
      expect(array.my_none?).not_to eql(true)
    end

    it 'returns true if the block given never returns true' do
      expect(range.my_none? { |x| x > 10 }).to eql(true)
    end

    it 'doesn\'t returns true if the block given ever returns true' do
      expect(array.my_none? { |x| x == 3 }).not_to eql(true)
    end

    it 'returns true if pattern === element is false for all elements' do
      expect(array.my_none?(Float)).to eql(true)
    end

    it 'doesn\'t returns true if pattern === element is true for an element' do
      expect(array_boolean.my_none?(nil)).not_to eql(true)
    end

    it 'return true when an argument is given and none case is true' do
      expect(range.my_none?(7)).to eql(true)
    end

    it 'doesn\'t return true when an argument is given and at least one case is true' do
      expect(array_boolean.my_none?(true)).not_to eql(true)
    end

    it 'return true when a RegExp is given and none case is true' do
      expect(array_string.my_none?(/[1-9]/)).to eql(true)
    end
  end

  describe '#my_count' do
    it 'returns total items of an array if block is not given' do
      expect(array.my_count).to eql(6)
    end

    it 'returns of characters of a string given like argument' do
      class String
        include Enumerable
      end
      expect(string.my_count('n')).to eql(1)
    end

    it 'returns an Integer equal to number of true cases when block is given' do
      expect(array.my_count(&:odd?)).to eql(3)
    end
  end

  describe '#my_map' do
    it 'returns a Enumerator, unless a block is given' do
      expect(array.my_map).to be_an_instance_of(Enumerator)
    end

    it 'returns a new array when block is given' do
      expect(array.my_map { |n| n * 2 }).to eql([2, 4, 6, 8, 10, 12])
    end

    it 'returns a new array when a proc is given' do
      expect(array.my_map(&process)).to eql([3, 4, 5, 6, 7, 8])
    end

    it 'returns proc output if a proc and block are given' do
      expect(array.my_map(process) { |n| n * 2 }).to eql([3, 4, 5, 6, 7, 8])
    end
  end

  describe '#my_inject' do
    it 'returns the combination of all elements by applying a symbol' do
      expect(range.my_inject(:+)).to eql(21)
    end

    it 'returns the combination of initial and all elements by applying a symbol' do
      expect(range.my_inject(2, :+)).to eql(23)
    end

    it 'returns the combination of the block passed for the accumulator and each element' do
      expect(array.my_inject { |x, y| x + y }).to eql(21)
    end

    it 'returns the combination of the block passed for the initial and and each element' do
      expect(array.my_inject(2) { |x, y| x + y }).to eql(23)
    end
  end
end
