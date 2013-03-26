require 'thread'

    # An implementation of an AVL Tree: http://en.wikipedia.org/wiki/AVL_tree
    # Copyright (C) 2012 Fabio Arciniegas 

    # This program is free software: you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation, either version 3 of the License, or
    # (at your option) any later version.

    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.

    # You should have received a copy of the GNU General Public License
    # along with this program.  If not, see <http://www.gnu.org/licenses/>.

class AVLTree
  attr_accessor :value,:left,:right,:balance

  def initialize(value=nil)
    @value, @left, @right, @balance = value, nil, nil, :even
  end
  
  def visit(order= :preorder,&block)
    case order 
    when :preorder
      yield @value
      @left.preorder(&block) unless @left.nil?
      @right.preorder(&block) unless @right.nil?
    when :inorder
      @left.inorder(&block) unless  @left.nil?
      yield @value
      @right.inorder(&block) unless @right.nil?
    when :postorder
      @left.postorder(&block) unless @left.nil?
      @right.postorder(&block) unless @right.nil?
      yield @value
    end
  end

  def preorder(&block)  visit(:preorder,&block) end
  def inorder(&block)   visit(:inorder,&block)   end
  def postorder(&block) visit(:postorder,&block) end

  def empty?
    @value.nil?
  end

  def higher(a,b)
    return false if b == :even
    return a != b
  end

  def balance_right_side!
    higher_tree = true
    # case 3 (case 1 is no move). simple rotate right
    if @right.balance == :right
      rotate_left!
      @left.balance, @balance = :even, :even
      higher_tree = false
    else  @right.balance == :left
    # case 5 
      case @right.left.balance
      when :left
        @balance, @right.balance = :even, :right
      when :right
        @balance, @right.balance = :left, :even
      when :even
        @balance, @right.balance = :even, :even
      end
      @right.left.balance = :even
      @right.rotate_right!
      rotate_left!
      higher_tree = false
    end
    higher_tree
  end

  def balance_left_side!
    higher_tree = true
    # case 2 (case 1 is no move). simple rotate right
    if @left.balance == :left 
      rotate_right!
      @right.balance, @balance = :even, :even
      higher_tree = false
    else
    # case 4 @left.balance == :right
      case @left.right.balance
      when :left
        @balance, @left.balance = :right, :even
      when :right
        @balance, @left.balance = :even, :left
      when :even
        @balance, @left.balance = :even, :even        
      end
      @left.right.balance = :even
      @left.rotate_left!
      rotate_right!
      higher_tree = false
    end
    higher_tree
  end


  def update_balance_left(old)
    case old
    when :even
      @balance = :left
    when :left
      @balance = :left
    when :right
      @balance = :even
    end
  end

  def update_balance_right(old)
    case old
    when :even
      @balance = :right
    when :left
      @balance = :even
    when :right
      @balance = :right
    end
  end
    
  # update each node on the path to the insertion with the new balance
  # return whether the tree is higher after the insertion
  def insert(v)
    old_balance,higher_tree = @balance, false
    @value = v  if empty?
    case @value <=> v
    when 1
      if @left.nil?
        @left = AVLTree.new(v)
        update_balance_left(old_balance)
        higher_tree = (old_balance == :even)
      else
        higher_tree = @left.insert(v) 
        update_balance_left(old_balance) if higher_tree
        case @balance
          when :even
            higher_tree = false
          when :left
            higher_tree = balance_left_side! if higher_tree and old_balance == :left
          when :right
            higher_tree = false
        end
      end
    when -1
      if @right.nil?
        @right = AVLTree.new(v)
        update_balance_right(old_balance)
        higher_tree = (old_balance == :even)
      else
        higher_tree = @right.insert(v) 
        update_balance_right(old_balance) if higher_tree
        case @balance
          when :even
            higher_tree = false
          when :right
            higher_tree = balance_right_side! if higher_tree and old_balance == :right
          when :left
            higher_tree = false
        end
      end
    end
    higher_tree
  end

  def contains?(v)
    return true if v == @value
    return @left.contains?(v) if !@left.nil? and v < @value
    return @right.contains?(v) if !@right.nil? and v > @value
    return false
  end

  def count_leafs
    return 0 if empty?
    return 1 if @left.nil? and @right.nil?
    left = @left.nil? ? 0 : @left.count_leafs
    right = @right.nil? ? 0 : @right.count_leafs
    return left+right
  end 

  def count
    left = @left.nil? ? 0 : @left.count
    right = @right.nil? ? 0 : @right.count
    return 1 + left + right
  end

  def path?(v1,v2)
    return contains?(v2) if v1 == @value
    is_left = @left.path?(v1,v2) if !@left.nil?
    return (is_left or @right.path?(v1,v2)) if !@right.nil? 
  end

  def count_at_level(level,current=0)
    return 0 if level < 0 
    return 1 if current == level
    l,r = 0,0
    l = @left.count_at_level(level,current+1) if !@left.nil?
    r = @right.count_at_level(level,current+1) if !@right.nil?
    return l + r
  end

  def similar?(tree)
    (tree.count == count) and includes?(tree)
  end

  def is_leaf?()
    left.nil? and right.nil?
  end

  def includes?(tree)
    return true if tree.nil? or tree.empty?
    contains?(tree.value) and includes?(tree.left) and includes?(tree.right)
  end

  def levels(explicit_nils=false,&block)
    queue = Queue.new
    queue << self
    elements_in_this_level,elements_in_next_level = 1,0
    level = 0
    begin
      tree = queue.pop
      yield tree.value,level if !tree.nil?
      yield nil,level if tree.nil?
      if !tree.nil? and (!tree.left.nil? or explicit_nils)
        queue << tree.left
        elements_in_next_level += 1 
      end
      if !tree.nil? and (!tree.right.nil? or explicit_nils)
        queue << tree.right
        elements_in_next_level += 1 
      end
      elements_in_this_level -= 1
      if elements_in_this_level == 0
        level += 1 
        elements_in_this_level, elements_in_next_level = elements_in_next_level, 0
      end
    end while !queue.empty? 
  end

  def iterative_inorder(&block)
    stack = Array.new
    tree = self
    while !tree.nil? or !stack.empty? do
      if !tree.nil? 
          stack.push tree if !tree.nil? 
          tree = tree.left
      else
        tree = stack.pop
        yield tree.value
        tree = tree.right
      end
    end
  end

  def depth
    ld,rd=0,0
    ld = @left.depth if !@left.nil?
    rd = @right.depth if !@right.nil?
    return 1 + [ld,rd].max
  end

  def inspect(explicit_nil="")
    print_tree.join("\n")
  end
  
  def print_tree(x=0,result=Array.new,level=0,out=nil,max_width=nil)
    result[level] = "" if result[level].nil?
    length,left_space,right_space = @value.to_s.length, 0,0
    out = Array.new if out.nil?
    max_width = spaces_needed if max_width.nil?
    to_x_space = x - result[level].length 
    result[level] << " "*to_x_space 

    left_space = 1 + @left.spaces_needed if !@left.nil?
    result[level] << " "*left_space 
    sv = result[level].length 
    out_0 = sv
    out_1 = sv+ @value.to_s.length 
    result[level]  << @value.to_s 
    # TODO: make printing of balance optional, for the moment uncomment if you want to see
    #    result[level] << " " << (@balance == :left ? "L" : (@balance == :right ? "R" : "C"))

    if  !@left.nil?
      @left.print_tree(x,result,level+2,out,max_width) 
      result[level+1] = " "*max_width if result[level+1].nil?      
      line_length = sv-out[1]-1
      left_char = "/"
      right_char = " "
      line_char = "`"
       line =  left_char + line_char*line_length
      result[level+1].insert(out[1],line)    
    end
    
    if  !@right.nil?
      @right.print_tree(x+left_space+length+1,result,level+2,out,max_width) 
      result[level+1] = " "*max_width if result[level+1].nil?
      line_length = out[0]-(sv+length+1)
      left_char = " "
      right_char = "\\"
      line_char = "`"
      line =  line_char*line_length + right_char
      result[level+1].insert(sv+length,line)    
    end

    out[0] = out_0
    out[1] = out_1
    result
  end

  def set_children(left, right)
    @left = left
    @right = right
  end
  
  def rotate_right!
    @value, @left.value = @left.value, @value
    @balance, @left.balance = @left.balance, @balance
    old_right = @right
    @left, @right = @left.left, @left
    @right.left, @right.right = @right.right, old_right
    self
  end

  def rotate_left!
    @value, @right.value = @right.value, @value
    @balance, @right.balance = @right.balance, @balance
    old_left = @left
    set_children(@right, @right.right)
    @left.set_children(old_left, @left.left)
    self
  end

  def isAVL
    ld =  !@left.nil? ? @left.depth : 0
    rd =  !@right.nil? ? @right.depth : 0
    lis =  !@left.nil? ? @left.isAVL : true
    ris =  !@right.nil? ? @right.isAVL : true
    (ld - rd).abs <= 1 and lis and ris
  end

protected
 def spaces_needed
   return @value.to_s.length  if is_leaf?
   ls,rs = 0,0
   ls = @left.spaces_needed if !@left.nil?
   rs =  @right.spaces_needed if !@right.nil?
   space = 0
   space += 1 if ls > 0
   space += 1 if rs > 0
   ls + rs + space + @value.to_s.length 
 end


end

tree2 = AVLTree.new
a = Array.new
(0...30).each do |n| a << n end
a.shuffle.each do |n| 
tree2.insert(n) 
print tree2.inspect << "\n"
STDIN.gets
end
