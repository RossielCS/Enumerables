require './main'

describe Enumerable do
  let(:array) { [1, 2, 3, 4, 5, 6] }

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
end
