#
# ==============
# |  创建集合  |
# ==============
#
# to_set
# ~~~~~~
# require 'set'之后，可以对Enumerable对象调用来创建集合。
require 'set'
(1..5).to_set   # => #<Set: {1, 2, 3, 4, 5}>
[1,2,3].to_set  # => #<Set: {1, 2, 3}>

# Set.new 
Set.new(1..5)                 # => #<Set: {1, 2, 3, 4, 5}>
Set.new([1,2,3])              # => #<Set: {1, 2, 3}>
Set.new([1,2,3])  {|x| x+1 }  # => #<Set: {2, 3, 4}>

# []
Set["cow", "pig", "hen"]      # => #<Set: {"cow", "pig", "hen"}>

# ------------------------------------------------------------------------------
#
# ======================
# |  测试，比较和联合  |
# ======================
#
# 测试是否包含元素
# ~~~~~~~~~~~~~~~~
s = Set.new(1..3)     # => #<Set: {1, 2, 3}>
s.include? 1          # => true 
s.member? 0           # => false 

# 子集，真子集和超集，真超集
# ~~~~~~~~~~~~~~~~~~~~~~~~~~
s = Set[2, 3, 5]
t = Set[2, 3, 5, 7]
s.superset? t         # => true 
t.superset? s         # => false 
s.proper_subset? t    # => true
t.superset? s         # => true
t.proper_superset? s  # => true 
s.subset? s           # => true
s.proper_subset? s    # => false 

# 大小方法
# ~~~~~~~~
s = Set[2, 3, 5]
s.length              # => 3
s.size                # => 3: a synonym for length
s.empty?              # => false
Set.new.empty?        # => true 

# 联合集合
# ~~~~~~~~
#
# Here are two simple sets 
primes = Set[2, 3, 5, 7]
odds = Set[1, 3, 5, 7, 9]

# The intersection is the set of values that appear in both 
primes & odds               # => #<Set: {5, 7, 3}>
primes.intersection(odds)   # this is an explicitly named alias

# The union is the set of values that appear in either 
primes | odds               # => #<Set: {5, 1, 7, 2, 3, 9}>
primes.union(odds)          # => an explicitly named alias 

# a-b: is the elements of a except for those also in b 
primes-odds                 # => #<Set: {2}>
odds-primes                 # => #<Set: {1, 9}>
primes.difference(odds)     # A named method alias 

# a^b is the set of values that appear in one set but not both:(a|b)-(a&b)
primes ^ odds               # => #<Set: {1, 2, 9}>

# ------------------------------------------------------------------------------
#
# ========================
# |  增加和删除集合元素  |
# ======================== 
#
# <<
# ~~
# 用于向集合中增加一个元素
s = Set[]
s << 1              # => #<Set: {1}>
s.add 2             # => #<Set: {1, 2}>
s << 3 << 4 << 5    # => #<Set: {1, 2, 3, 4, 5}>
s.add 3             # unchanged
s.add? 6            # => #<Set: {1, 2, 3, 4, 5, 6}>
s.add? 3            # => nil 

# merge
# ~~~~~
# 用于向集合增加多个元素
s = (1..3).to_set   # => #<Set: {1, 2, 3}>
s.merge(2..5)       # => #<Set: {5, 1, 2, 3, 4}>

# delete
# ~~~~~~
# 用于删除集合的元素
s = (1..3).to_set   # => #<Set: {1, 2, 3}>
s.delete 1          # => #<Set: {2, 3}>
s.delete 1          # => unchanged
s.delete? 1         # => nil 
s.delete? 2         # => #<Set: {3}>

# subtract
# ~~~~~~~~
# 用于删除多个对象
s = (1..3).to_set   # => #<Set: {1, 2, 3}>
s.subtract(2..10)   # => #<Set: {1}>
  
# delete_if,reject!
# ~~~~~~~~~~~~~~~~~
# 根据块的处理结果删除对象，
# delete_if始终返回接收者对象，
# reject!在集合有变化时返回接收者对象，否则返回nil 
primes = Set[2, 3, 5, 7]
primes.delete_if {|x| x%2 == 1 }    # => #<Set: {2}>: remove odds 
primes.delete_if {|x| x%2 == 1 }    # => #<Set: {2}>: unchanged 
primes.reject! {|x| x%2 == 1 }      # => nil 

# Do an in-place intersection like this:
s = (1..5).to_set 
t = (4..8).to_set 
s.reject! {|x| not t.include? x }

# clear,replace
# ~~~~~~~~~~~~~
s = Set.new(1..3)
s.replace(3..4)   # => #<Set: {3, 4}>
s.clear           # => #<Set: {}>
s.empty?          # => true 

# ------------------------------------------------------------------------------
#
# ================
# |  集合迭代器  |
# ================
#
s = Set[1, 2, 3, 4, 5]
s.each {|x| print x }   # prints "12345"
s.map! {|x| x*x }       # => #<Set: {16, 1, 25, 9, 4}>
s.collect! {|x| x/2 }   # => #<Set: {0, 12, 2, 8, 4}>

# ------------------------------------------------------------------------------
#
# ==================
# |  集合杂项方法  |
# ==================
#
s = (1..3).to_set 
s.to_a    # => [1,2,3]
s.to_s    # => "#<Set:0x8c0698c>"
s.inspect # => "#<Set: {1, 2, 3}>"
s == Set[1,2,3]   # => true: use eql? to compare set elements 

# classify
# ~~~~~~~~
# 根据代码块将集合分成子集，返回哈希表
# Classify set elements as even or odd 
s = (0..3).to_set
s.classify {|x| x%2 }   # => {0=>#<Set: {0,2}>, 1=>#<Set: {1, 3}>}

# divide
# ~~~~~~
s.divide {|x| x%2 }     # => #<Set: {#<Set: {1, 3}>, #<Set: {2}>}>

s = %w[ant ape cow hen hog].to_set
s.divide {|x,y| x[0]==y[0] }  
# => #<Set: {#<Set: {"ant", "ape"}>, #<Set: {"cow"}>, #<Set: {"hen", "hog"}>}>

# ------------------------------------------------------------------------------
