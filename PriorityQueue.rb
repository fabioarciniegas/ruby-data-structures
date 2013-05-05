#TODO: refactor into various heaps for various implementations
class PriorityQueue
attr_reader :value
alias :peek :value

  def initialize(value=nil)
    @q = Array.new
    @q << value unless value.nil?
  end

  def insert(value)
    @q << value
    heapifyUp 
  end

  def length
    @q.length
  end
  alias :size :length
  alias :weight :length

  alias :<< :insert
  alias :offer :insert

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

  def isHeap(index=0)
    left,right = index*2+1,index*2+2
    return true if left > @q.length-1 
    answer = @q[index] > @q[left]
    return answer if right > @q.length-1 
    answer = @q[index] > @q[right]
    answer && isHeap(left) && isHeap(right)
  end

protected
  def heapifyUp(index=@q.length-1)
    parent = index % 2 == 1 ? (index-1)/2 : (index-2)/2
    while parent >= 0
      stop = true
      v = @q[index]
      p = @q[parent]
      if v > p
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
      if l > v && l >= r 
        @q[left],@q[index] = v,l
        index = left
        stop = false
      elsif r > v && r >= l 
        @q[right],@q[index] = v,r
        index = right
        stop = false
      end
      left,right = stop ? @q.length : index*2+1,index*2+2
    end
  end

end 
