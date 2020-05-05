require './main'

describe Enumerable do
  let(:array) { [1, 2, 3, 4, 5, 6] }
  let(:array_boolean) { [true, true, nil, false, true, true] }
  let(:array_false) { [nil, false] }
  let(:range) { (1..6) }
  let(:string) { 'a string' }
  let(:process) { Proc.new { |n| n + 2 } }

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

    it 'returns false if an item is false or nil' do
      expect(array_boolean.my_all?).to eql(false)
    end

    it 'when block is given, it returns true if all cases are true' do
      expect(array.my_all? { |m| m.is_a? Integer }).to eql(true)
    end

    it 'when block is given, it returns false if at least one case is false' do
      expect(array.my_all? { |m| m > 1 }).to eql(false)
    end

    it 'when block is given, it returns true if all cases are true in a range' do
      expect(range.my_all? { |m| m.is_a? Integer }).to eql(true)
    end
  end

  describe '#my_any?' do
    it 'returns true if one of the elements is true' do
      expect(array_boolean.my_any?).to eql(true)
    end

    it 'returns false if none of the elements is true' do
      expect(array_false.my_any?).to eql(false)
    end

    it 'returns true if the block given ever returns true' do
      expect(array.my_any? { |x| x == 5 }).to eql(true)
    end

    it 'returns false if the block given never returns true' do
      expect(range.my_any? { |x| x == 8 }).to eql(false)
    end

    it 'returns true if pattern === element is true for an element' do
      expect(array_boolean.my_any?(nil)).to eql(true)
    end

    it 'returns false if pattern === element is false for all elements' do
      expect(array_false.my_any?(Integer)).to eql(false)
    end
  end

  describe '#my_none?' do
    it 'returns true if all the elements are false' do
      expect(array_false.my_none?).to eql(true)
    end

    it 'returns false if all the elements are true' do
      expect(array.my_none?).to eql(false)
    end

    it 'returns true if the block given never returns true' do
      expect(range.my_none? { |x| x > 10 }).to eql(true)
    end

    it 'returns false if the block given ever returns true' do
      expect(array.my_none? { |x| x == 3 }).to eql(false)
    end

    it 'returns true if pattern === element is false for all elements' do
      expect(array.my_none?(Float)).to eql(true)
    end

    it 'returns false if pattern === element is true for an element' do
      expect(array_boolean.my_none?(nil)).to eql(false)
    end
  end

  describe '#my_count' do
    it 'returns total items of an array if block is not given' do
      expect(array.my_count).to eql(6)
    end

    it 'returns of characters of a string given like argument' do
      expect(string.my_count('n')).to eql(1)
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
end
