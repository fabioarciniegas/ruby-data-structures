# A heap organizes data so that requests for the next element in the heap always returns the largest
# element according to some order. 
#
# Heaps with a mathematical "greater than or equal to" comparison
# function are called max-heaps; those with a mathematical "less than
# or equal to" comparison function are called min-heaps. Min-heaps are
# often used to implement priority queues.  
# 
# http://en.wikipedia.org/wiki/Heap_(data_structure)
#
# == Usage
#
#    h = Heap.new(5)
#    h << 6 << 4 << 7 << 3
#    h.pop! 
#    => 7
#
class Heap
 # top value of the heap

  alias :peek :value
  #TODO: simplify/rubify

  # * +value+ optional root node value. If nil, size of the heap is 0.
  # * +block+ optional comparision block. By default block equivalent
  #   to a max-heap, that is return the highest element first (lambda
  #   { |x,y| (x <=> y) == 1}). Shortcut class declarations for MinHeap and
  #   MaxHeap are provided those are equivalent to
  #
  #   minheap = Heap.new(nil,lambda { |x,y| (x <=> y) == -1}) and
  #   maxheap = Heap.new(nil,lambda { |x,y| (x <=> y) == 1})
  def initialize(value=nil,&block)
    @q = Array.new
    @q << value unless value.nil?
    @compare = block || lambda { |x,y| (x <=> y) == 1}
  end

  
  # insert value in BinaryHeap and returns self
  # rearranges heap so all properties are maintained
  def insert(value)
    @q << value
    heapifyUp 
  end

  # number of elements in heap
  def length
    @q.length
  end
  alias :size :length
  alias :weight :length

  alias :<< :insert
  alias :offer :insert

  # return and remove the top of the heap. use #peek for returning top
  # of the heap without removing it.
  # rearranges heap so all properties are maintained
  def pop!
    a = @q.first
    @q[0],@q[@q.length-1] = @q.last,@q.first
    @q.pop
    heapifyDown 
    a
  end
  alias :poll :pop!

  def empty?
    @q.empty?
  end

  # verify invariant. 
  # TODO: include this and prettyprint as mixin 
  def isHeap(index=0)
    left,right = index*2+1,index*2+2
    return true if left > @q.length-1
    answer = @compare[@q[index],@q[left]]
    return answer if right > @q.length-1
    answer = @compare[@q[index],@q[right]]
    answer && isHeap(left) && isHeap(right)
  end

  # returns the top of the heap. does not remove it
  def value
    @q.first
  end


protected
  def heapifyUp(index=@q.length-1)
    parent = index % 2 == 1 ? (index-1)/2 : (index-2)/2
    while parent >= 0
      stop = true
      v = @q[index]
      p = @q[parent]
      if @compare[v,p]
        @q[index],@q[parent] = p,v
        index = parent
        parent = index % 2 == 1 ? (index-1)/2 : (index-2)/2
        stop = false
      end
      parent = -1 if stop
    end
  end

  def heapifyDown(index=0)
    left,right = index*2+1,index*2+2
    while left < @q.length
      stop = true
      v = @q[index]
      l = @q[left]
      r = right < @q.length ? @q[right] : v
      if @compare[l,v] && @compare[l,r]
        @q[left],@q[index] = v,l
        index = left
        stop = false
      elsif @compare[r,v]
        @q[right],@q[index] = v,r
        index = right
        stop = false
      end
      left,right = stop ? @q.length : index*2+1,index*2+2
    end
  end

end 
