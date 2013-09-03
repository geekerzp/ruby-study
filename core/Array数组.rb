#
# ==============
# |  创建数组  |
# ==============
#
# 1. 通过字面量(literal)创建
# ~~~~~~~~~~~~~~~~~~~~~~~~~~
[1,2,3]
[]
[]
%w[a b c]
Array[1,2,3]

# 2. 显式创建
# ~~~~~~~~~~~
# Creating arrays with the new() method 
empty = Array.new
nils = Array.new(3)
copy = Array.new(nils)
zeros = Array.new(4, 0)
count = Array.new(3) {|i| i+1 }

# Be careful with repeated objects 
a = Array.new(3,'a')    # => ['a','a','a']: three references to the same string
a[0].upcase!            # Capitalize the first element of the array 
a                       # => ['A','A','A']: they are all the same string!
a = Array.new(3) {'b'}  # => ['b','b','b']: three distinct string objects 
a[0].upcase!            # Capitalize the first one 
a                       # => ['B','b','b']: the others are still lowercase 
#
# ------------------------------------------------------------------------------
# 
# ==========================
# |  数组大小和其中的元素  |
# ==========================
#
# Array length
[1,2,3].length
[].size 
[].empty? 
[nil].empty?              # => false

# Indexing single elements 
a = %w[a b c d]
a[0]
a[-1]
a[a.size-1]
a[-a.size]  # => 'a'
a[5]        # => 'nil'
a[-5]       # => 'nil'
a.at(2)     # => 'c'
a.fetch(1)  # => 'b'
a.fetch(-1) # => 'd'
a.fetch(5)  # => IndexError!: does not allow out-of-bounds
a.fetch(-5) # => IndexError!: does not allow out-of-bounds
a.fetch(5,0)# => 0: return 2nd arg when out-of-bounds
a.fetch(5) {|x| x*x } # => 25: compute value when out-of-bounds
a.first
a.last
  
# Indexing subarrays 
a[0,2]
a[0..2]
a[0...2]
a[1,1]
a[-2,2]
a[4,2]      # => []: empty array right at the end 
a[5,1]      # => nil: nothing beyond that 
a.first(3)
a.last(1)

# Extracting arbitrary values 
a.values_at(0,2)      # => ['a','c']
a.values_at(4,3,2,1)  # => [nil, 'd', 'c', 'b']
a.values_at(0,2..3,-1)# => ['a', 'c', 'd', 'd']
a.values_at(0..2,1..3)# => ['a', 'b', 'c', 'b', 'c', 'd']
#
# ------------------------------------------------------------------------------
#
# ==================
# |  该变数组元素  |
# ==================
#
a = [1,2,3]
# Changing the value of elements
a[0] = 0        # => [0,2,3]
a[-1] = 4       # => [0,2,4]
a[1] = nil      # => [0,nil,4]

# Appending to an array 
a = [1,2,3]
a[3] = 4        # => [1,2,3,4]
a[5] = 6        # => [1,2,3,4,nil,6]
a << 7          # => [1,2,3,4,nil,6,7]
a << 8 << 9     # => [1,2,3,4,nil,6,7,8,9]
a = [1,2,3]
a + a           # => [1,2,3,1,2,3]
a.concat([4,5]) # => [1,2,3,4,5]

# Inserting elements with insert 
a = ['a', 'b', 'c']
a.insert(1, 2, 3)   # => ['a', 2, 3, 'b', 'c', 'd']

# Removing (and returning) individual elements by index 
a = [1,2,3,4,5,6]
a.delete_at(4)    # => [1,2,3,4,6]
a.delete_at(-1)   # => [1,2,3,4]
a.delete_at(4)    # => [1,2,3,4]

# Removing elements by value 
a.delete(4)   # => [1,2,3]
a[1] = 1      # => [1,1,3]
a.delete(1)   # => [3]
a = [1,2,3]
a.delete_if {|x| x%2==1 }   # => [2]
a.reject! {|x| x%2==0 }     # => []: same as delete_if 

# Removing elements and subarrays with slice! 
a = [1,2,3,4,5,6,7,8]
a.slice!(0)     # => [2,3,4,5,6,7,8]
a.slice!(-1,1)  # => [2,3,4,5,6,7]
a.slice!(2..3)  # => [2,3,6,7]
a.slice!(4,2)   # => [2,3,6,7]
a.slice!(5,2)   # => [2,3,6,7]

# Replacing subarrays with []=
# To delete, assign an empty array 
# To insert, assign to a zero-width slice 
a = ('a'..'e').to_a         # => ['a', 'b', 'c', 'd', 'e']
a[0,2] = ['A','B']          # => ['A', 'B', 'c', 'd', 'e']
a[2...5] = ['C', 'D', 'D']   # => ['A', 'B', 'C', 'D', 'E']
a[0,0] = [1,2,3]            # => [1,2,3,'A', 'B', 'C', 'D', 'E']
a[0..2] = []                # => ["A", "B", "C", "D", "E"]
a[-1,1] = ['Z']             # => ['A', 'B', 'C', 'D', 'Z']
a[-1,1] = 'z'               # => ["A", "B", "C", "D", "z"]
a[1,4] = nil                # => ['A',nil]

# Other methods 
a = [4, 5]
a.replace([1,2,3])          # => [1,2,3]
a.fill(0)                   # => [0,0,0]
a.fill(nil,1,3)             # => [0,nil,nil,nil]
a.fill('a',2..4)            # => [0,nil,'a','a','a']
a[3].upcase!                # => [0,nil,'A','A','A']
a.fill(2..4) {'b'}          # => [0,nil,'b','b','b']
a[3].upcase!                # => [0,nil,'b','B','b']
a.compact                   # => a copy: [0,'b','B','b']
a.compact!                  # => [0,'b','B','b']
a.clear                     # => []
#
# ------------------------------------------------------------------------------
#
# ======================
# |  迭代，搜索和排序  |
# ======================
#
a = ['a','b','c']
a.each {|elt| print elt }
a.reverse_each {|elt| print elt }
a.cycle {|e| print e }
a.each_index {|i| print i }   
a.each_with_index {|e,i| print e,i }
a.map {|x| x.upcase }
a.map! {|x| x.upcase }
a.collect {|x| x.downcase }

# Searching methods 
a = %w[h e l l o]
a.include?('e')     # => true 
a.include?('w')     # => false 
a.index('l')        # => 2
a.index('L')        # => nil 
a.rindex('l')       # => 3
a.index {|x| x =~ /[aeiou]/}  # => 1
a.rindex {|x| x =~ /[aeiou]/} # => 4

# Sorting
a.sort    # => a copy: ["e", "h", "l", "l", "o"]
a.sort!   # => ["e", "h", "l", "l", "o"]
a = [1,2,3,4,5]
a.sort! {|a,b| a%2 <=> b%2 }    # => [2, 4, 3, 1, 5]

# Shuffling arrays: the opposite of sorting 
a = [1,2,3]
puts a.shuffle
#
# ------------------------------------------------------------------------------
#
# ==============
# |  数组比较  |
# ==============
#
# 当且仅当两个数组具有相同的元素时，且这些元素具有相同的值，
# 并以相同的顺序出现时，我们才认为这两个数组是相等的。
# ==方法通过包含元素的==方法来检测相等性，
# eql?方法通过包含元素的eql?方法来检测相等性。
#
[1,2] <=> [4,5]     # => -1 because 1<4
[1,2] <=> [0,0,0]   # => +1 because 1>0
[1,2] <=> [1,2,3]   # => -1 because first array is shorter
[1,2] <=> [1,2]     # => 0  they are equal 
[1,2] <=> []        # => +1 always less than a nonempty array 
#
# ------------------------------------------------------------------------------
#
# ================================
# |  作为栈(stack)和队列(queue)  |
# ================================
#
# 1. 作为一个栈(Array as a stack)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a = []
a.push(1)     # => [1]
a.push(2,3)   # => [1,2,3]
a.pop         # => 3
a.pop         # => 2
a.pop         # => 1
a             # => []

# 2. 作为一个队列(Array as a queue)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a = []
a.push(1)     # => [1]
a.push(2,3)   # => [1,2,3]
a.shift       # => 1
a.shift       # => 2
a.shift       # => 3
a             # => []

# ------------------------------------------------------------------------------
#
# ===================
# |  作为集合(set)  |
# ===================
#
[1,3,5] & [1,2,3]     # => [1,3]
[1,1,3,5] & [1,2,3]   # => [1,3]
[1,3,5] | [2,4,6]     # => [1,2,3,4,5,6]
[1,3,5,5] | [2,4,6,6] # => [1,2,3,4,5,6]
[1,2,3] - [2,3]       # => [1]
[1,1,2,2,3,3] - [2,3] # => [1,1]

small = 0..10.to_a            # A set of small number 
even = 0..50.map {|x| x*2 }   # A set of even number
smalleven = small & even      # Set intersection 
smalleven.include?(8)         # true 

[1,1,nil,nil].uniq            # => [1,nil]

# 用来计算排列组合
# ~~~~~~~~~~~~~~~~
a = [1,2,3]
# Iterate all possible 2-element subarrays (order matters)
a.permutation(2) {|x| print x }   # Prints"[1,2][1,3][2,1][2,3][3,1][3,2]"

# Iterate all possible 2-element subsets (order does not matters)
a.combination(2) {|x| print x }   # Prints"[1,2][1,3][2,3]"

# Return the cartesian product of the two sets 
a.product(['a','b'])    # => [[1,'a'],[1,'b'],[2,'a'],[2,'b'],[3,'a'],[3,'b']]

#
# ------------------------------------------------------------------------------
#
# ==================
# |  关联数组方法  |
# ==================
#
# 使用assoc和rassoc方法，可以把数组作为关联数组或哈希表来使用。
h = { :a => 1, :b => 2}   # Start with a hash
a = h.to_a                # => [[:b,2],[:a,1]]: associative array 
a.assoc(:a)               # => [:a,1]: subarray for key :a
a.assoc(:b).last          # => 2: value for key :b
a.rassoc(1)               # => [:a,1]: subarray for value 1
a.rassoc(2).first         # => :b: key for value 2
a.assoc(:c)               # => nil 
a.transpose               # => [[:a,:b],[1,2]]
#
# ------------------------------------------------------------------------------
#
# ==================
# |  数组杂项方法  |
# ==================
#
# Conversion to strings 
[1,2,3].join         # => "123"
[1,2,3].join(', ')   # => "1, 2, 3"
[1,2,3].to_s         # => "[1,2,3]"
[1,2,3].inspect      # => "[1,2,3]"

# Binary conversion with pack
[1,2,3,4].pack("CCCC")    # => "\x01\x02\x03\x04"
[1,2].pack("s2")          # => "\x01\x00\x02\x00"
[1234].pack("i")          # => "\xD2\x04\x00\x00"

# Other method 
[0,1]*3                    # => [0,1,0,1,0,1]
[1, [2, [3]]].flatten      # => [1,2,3]
[1, [2, [3]]].flatten(1)   # => [1,2,[3]]
[1,2,3].reverse            # => [3,2,1]
a=[1,2,3].zip([:a,:b,:c])  # => [[1,:a],[2,:b],[3,:c]]
a.transpose                # => [[1,2,3],[:a,:b,:c]]
#
# ------------------------------------------------------------------------------
