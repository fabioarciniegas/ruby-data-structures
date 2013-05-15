# BinaryHeap organizes nodes efficiently so that the highest node is
# always on top. It is one way to implement priority queues.
#
# More formally, BinaryHeaps are binary trees satisfying two additional properties: shape, and heap.
#
# The <b>shape property</b> states that the tree is a complete binary tree, that is all levels of the tree 
# except possibly the last one are fully filled. If the last level of the tree is not complete, the nodes
# are filled left to right.
# 
# The <b>heap property</b> states that each node is greater or equal than both of its children
#
# Note that no guarantees are made about the relative values of the children.
#
# A BinaryHeap can be used to implement a priority queue. However, the PriorityQueue implementation using
# arrays is more common and faster.
#
# == Note on tree Representation
#
# Heaps are usually represented as arrays. However, heaps are often explained in terms of a tree structure
# (a BinaryHeap). This class is a working implementation of the intuitive tree-based explanation; use the 
# PriorityQueue class for a faster implementation 
#
# == Usage
#
#    h = BinaryHeap.new(5)
#    h << 6 << 4 << 7 << 3
#    h.pop! 
#    => 7
#
class BinaryHeap
  # top value of the heap
  attr_reader :value

  # number of elements in the heap
  attr_reader :weight

  alias :size :weight
  alias :peek :value 

  # * +value+ optional root node value. If nil, weight of the tree is 0.
  # * +parent+ parent tree. Internal use only. This implementation uses an extra
  # reference to the tree node to speed up lookups for
  # insertion/deletion. This value does not need to be set by callers. 
  #
  # An alternative implementation could hide this parameter and provide a factory method or 
  # a difference between BinaryHeap and Node, but this is implementation is clear enough and simplest, 
  # therefore preferred.  
  # 
  #    h = BinaryHeap.new(5)
  #    h << 6 << 4 << 7 << 3
  #    h.pop! 
  #    => 7
  #
  def initialize(value=nil,parent=nil)
    @value, @left, @right, @parent, @ip = value, nil, nil, parent, self
    @weight = value.nil? ? 0 : 1
  end

  # call-seq:
  # insert(value) -> this
  #
  # Insert value in BinaryHeap and returns self
  # rearranges heap so all properties are maintained
  def insert(value)
    @weight = @weight+1
    if !@ip.empty? && !@ip.left.nil? && !@ip.right.nil?
      if !@ip.parent.nil?
        @ip = @ip.parent.next_right_sibling(@ip == @ip.parent.right) 
      else
        @ip = @ip.left 
      end
    end
     if empty?
       @value = value
     elsif @ip.left.nil?
       @ip.left = BinaryHeap.new(value,@ip)
       @ip.left.heapify_up
     elsif @ip.right.nil?
       @ip.right = BinaryHeap.new(value,@ip)
       @ip.right.heapify_up
     end
    self
   end
  alias :<< :insert
  alias :push :insert

  # return and remove the top of the heap. use #peek for returning top
  # of the heap without removing it.
  # rearranges heap so all properties are maintained
   def pop!
     @weight = @weight > 0 ? @weight-1 : 0
     if @ip == self && @right.nil? && @left.nil?
       value,@value = @value,nil
       return value
     end
     if !@ip.right.nil? 
       answer,@value = @value,@ip.right.value
       @ip.right = nil
       heapify_down
       return answer
     elsif !@ip.left.nil?
       answer,@value = @value,@ip.left.value
       @ip.left = nil
       heapify_down
       @ip =  @ip.parent.nil? ? self : @ip.parent.next_left_sibling(@ip == @ip.parent.left)
       return answer
     end
     if @ip.right.nil? && @ip.left.nil?
       @ip = @ip.parent.next_left_sibling(@ip == @ip.parent.left) unless @ip.parent.nil?
       pop!
     end
   end
   alias :poll :pop!

   # Returns true if self contains no elements.
   # Note a heap may be non-nil but empty. 
   #     h = BinaryHeap.new(3)
   #     h.pop!
   #     h.nil? 
   #     => false
   #     h.empty? 
   #     => true
   def empty?
     @value.nil?
   end


protected
   # return left child
   def left    
     @left  
   end
   # set left child
   def left=(value)    
     @left = value  
   end
   # return right child
   def right    
     @right  
   end
   # return parent node
   def parent    
     @parent  
   end
   # set right child
   def right=(value)    
     @right = value  
   end
   # set node value
   def value=(v)    
     @value = v  
   end

  # Determine the next right sibling of a particular node
  # used to determine the right place for insertion
  def next_right_sibling(from_right)
    # if it's climbing up from the right, keep going up the tree, but
    # if it's climbing up from the left we have found the right place.
    candidate = nil
    if from_right && !@parent.nil?
      candidate = @parent.next_right_sibling(@parent.right == self)
    elsif from_right && @parent.nil?
      candidate = self
    elsif !from_right 
      candidate = @right
    end
    while !candidate.left.nil? do
      candidate = candidate.left
    end
    candidate
  end

  # Determine the next left sibling of a particular node
  # used to determine the right place for deletion
  def next_left_sibling(from_left)
    # if it's climbing up from the left, keep going up the tree, but
    # if it's climbing up from the right we have found the right place.
    candidate = nil
    if from_left && !@parent.nil?
      candidate = @parent.next_left_sibling(@parent.left == self)
    elsif from_left && @parent.nil?
      candidate = self
    elsif !from_left 
      candidate = @left
    end
    while !candidate.right.nil? && !candidate.right.right.nil? do
      candidate = candidate.right
    end
    candidate
  end

  # swap the current node's value with it's parent's if lesser
  # used to rearrange tree on insertions see http://en.wikipedia.org/wiki/Binary_heap#Insert
  def heapify_up
    return if @parent.nil?
    if @parent.value < @value
      @parent.value,@value = @value,@parent.value
      @parent.heapify_up
    end
  end

  # swap the current node's value with it's biggest child
  # used to rearrange tree on deletions see http://en.wikipedia.org/wiki/Binary_heap#Delete
  def heapify_down
    l  = @left.nil? ? @value : @left.value
    r  = @right.nil? ? @value : @right.value
    if l > @value && l >= r
      @value,@left.value = @left.value,@value
      @left.heapify_down
    elsif r > @value && r >= l
      @value,@right.value = @right.value,@value
      @right.heapify_down
    end
  end
end

