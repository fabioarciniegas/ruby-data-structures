require_relative '../trees/BinaryHeap'

describe BinaryHeap do
  before :each do
    @heap = BinaryHeap.new(1)
  end

  describe "#new" do
    it "takes zero or one parameter with the node value" do
      @heap.should be_an_instance_of BinaryHeap
    end
  end

  describe ".insert" do
    it "should do insert" do
      @heap.insert(2)
      @heap.insert(3)
      @heap.weight.should eql 3
      @heap = BinaryHeap.new()
      @heap.insert(2)
      @heap.insert(3)
      @heap.weight.should eql 2
    end
  end

  describe ".pop!" do
    it "should do pop" do
      @heap.insert(2)
      @heap.insert(3)
      @heap.weight.should eql 3
      @heap.pop!.should eql 3
      @heap.pop!.should eql 2
      @heap.pop!.should eql 1
      @heap.weight.should eql 0
    end
  end

  describe "roundtrip with many elements" do
    it "should return items in order" do
      a = Array.new
      b = Array.new
      h = BinaryHeap.new
      (0...300).each do |n| a << n end
      (0...300).each do |n| b << n end
      a.shuffle
      a.each do |n| h << n end
      b.reverse_each do |n| h.pop!.should eql n end
      h.pop!.should eql nil
      h.weight.should eql 0
    end
  end

  describe "empty is not nil" do
    it "should be non-nil even if empty" do
      h = BinaryHeap.new
      h << 3
      a = h.pop!
      a.should eql 3
      h.nil?.should eql false
      h.empty?.should eql true
    end
  end

end
