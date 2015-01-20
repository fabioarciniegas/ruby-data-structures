require 'spec_helper'

describe Quicksort do

  # before :all would run only once
  before :each do
    @unsorted = [3,1,0,1]
    @sorted   = [0,1,1,3]
    @empty = Array.new
    @nil_array = nil

    @a = Array.new
    (0..20000).each do |n|  @a << rand(20000) end
  end 

  describe "#sorted?(a,i,j)" do
    it "true if for every valid index between i(inclusive) and j(exclusive) if i < j  a[i] <= a[j]" do
      expect(Quicksort.sorted?(@sorted,0,@sorted.length)).to be true
      expect(Quicksort.sorted?(@unsorted,0,@unsorted.length)).to be false
    end
    it "true for empty arrays" do
      expect(Quicksort.sorted?(@empty,0,1)).to be true
    end
    it "true for nil arrays" do
      expect(Quicksort.sorted?(@nil_array,0,1)).to be true
    end
    it "true whenever j < i" do
      expect(Quicksort.sorted?(@unsorted,1,0)).to be true
    end
  end

  describe "#sort" do
    it "sorts array elements from i (inclusive) to j (exclusive)" do
      expect(Quicksort.sorted?(@unsorted,0,@unsorted.length)).to be false
      Quicksort.sort(@unsorted,0,@unsorted.length)
      expect(Quicksort.sorted?(@unsorted,0,@unsorted.length)).to be true
      Quicksort.sort(@a,0,@a.length)
      expect(Quicksort.sorted?(@a,0,@a.length)).to be true
    end
  end

end 


