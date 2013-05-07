require_relative '../lib/containers/heap'

describe Heap do
  before :each do
    @heap = Heap.new(1)
  end

  describe "#new" do
    it "takes zero or one parameter with the node value" do
      @heap.should be_an_instance_of Heap
    end
  end

  describe ".insert" do
    it "should do insert and still be a heap" do
      @heap.insert(2)
      @heap.insert(3)
      @heap.weight.should eql 3
      @heap = Heap.new()
      @heap.insert(2)
      @heap.insert(3)
      @heap.weight.should eql 2
      @heap.isHeap.should eql true 
      (0...1001).each do |n| @heap << n end
      @heap.isHeap.should eql true 
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
      h = Heap.new
      (0...100).each do |n| a << n end
      (0...100).each do |n| b << n end
      a.shuffle
      h.isHeap.should eql true 
      a.each do |n| h << n end
      b.reverse_each do |n| 
        h.pop!.should eql n 
        h.isHeap.should eql true 
      end
      h.pop!.should eql nil
      h.weight.should eql 0
    end
  end

  describe "empty is not nil" do
    it "should be non-nil even if empty" do
      h = Heap.new
      h << 3
      a = h.pop!
      a.should eql 3
      h.nil?.should eql false
      h.empty?.should eql true
    end
  end

end
