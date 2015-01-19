    # An implementation of Quicksort: http://en.wikipedia.org/wiki/Quicksort
    # 2014 Fabio Arciniegas 

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

class Quicksort

  def self.partition(a,i,k)
    pivot = i+rand(k-i)
    j = i
    # put pivot as first element for simplicity
    a[i],a[pivot] = a[pivot],a[i] #ruby allows you this kind of syntactic sugar
    partition = j
    while j < k
      if a[j] <= a[i]
        a[j],a[partition] = a[partition],a[j]
        partition = partition + 1
      end
      j = j+1
    end
    partition = partition -1 # went off one more than needed in the last iteration
    a[i],a[partition] = a[partition],a[i]
    partition
  end

  def self.sort(a,i,l)
    return i unless l-i > 1    
    p = partition(a,i,l)
    sort(a,i,p)
    sort(a,p,l)
  end

end

a = Array.new
(0..2000000).each do |n|  a << rand(20000000) end
Quicksort.sort(a,0,a.length)
#a.each do |n| print n,"<" end

print a[0],"<",a[1000],"<",a[a.length-1]
