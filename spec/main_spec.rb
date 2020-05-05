require './main'

describe Enumerable do
  let(:array) { [1, 2, 3, 4, 5, 6] }
  let(:array_boolean) { [true, true, nil, false, true, true] }
  let(:range) { (1..6) }
  let(:string) { 'a string' }

  describe '#my_each' do
    it 'returns an enumerator if no block is given' do
      expect(array.my_each).to be_an_instance_of(Enumerator)
    end

    it 'returns the element if a block is given' do
      expect(array.my_each { |x| x * 2 }).to eql(array)
    end
  end

  describe '#my_each_with_index' do
    it 'returns an enumerator if no block is given' do
      expect(array.my_each_with_index).to be_an_instance_of(Enumerator)
    end

    it 'returns the element if a block is given' do
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
end
