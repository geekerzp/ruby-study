# -*- coding: utf-8 -*-
# 
# ==========
# |  Hash  |
# ==========
# ------------------------------------------------------------------------------
# =================
# |  哈希类的特点   |
# =================
# 优点：可以使用任何对象作为索引
# 缺点：它的元素是无序的，很难使用哈希实现栈和队列
# ------------------------------------------------------------------------------
# ================
# |  创建哈希表    |
# ================

{ :one => 1, :two => 2 }                    # Basic hash literal syntax 
{ one: 1, two: 2 }                          # Same, Ruby 1.9 syntax. Keys are symbols 
{}                                          # A new, empty, Hash object 
Hash.new                                    # => {}: creates empty hash 
Hash[:one, 1, :two, 2]                      # => {one:1, two:2}
Hash[[[1, 'a'], [2, 'b'], [3, 'c']]]        # => {1=>'a', 2=>'b', 3=>'c'}

# 当哈希表字面量作为方法调用的最后一个参数时，
# 可以省略大括号。
puts one:1, two:2
#
# ------------------------------------------------------------------------------
#
# ==========================
# |  哈希表索引和成员判别  |
# ==========================
#
h = { :one => 1, :two => 2 }
h[:one]   
h[:three]     # => nil 
h.assoc :one  # => [:one, 1]

h.index 1     # => :one 
h.index 4     # => nil
h.rassoc 2    # => [:two, 2]

h = { :a => 1, :b => 2 }
# Checking for the presence of keys in a hash: fast 
h.key?(:a)      # => true
h.has_key?(:b)  # => true 

# 一次提取一个值
h = { :a => 1, :b => 2 }
h.fetch(:a)     # => 1
h.fetch(:c)     # => IndexError 
h.fetch(:c, 33) # => 33 
h.fetch(:c) {|k| k.to_s }   # => "c"

# 一次提取多个值
h = { :a => 1, :b => 3, :c => 3 }
h.values_at(:c)         # => [3]
h.values_at(:a, :b)     # => [1, 2]
h.values_at(:d, :d, a)  # => [nil, nil, 1]

# 返回一组键值对
h = { :a => 1, :b => 2, :c => 3 }
h.select {|k,v| v % 2 == 0 }    # => {:b => 2}

# ------------------------------------------------------------------------------
#
# ==========================
# |  在哈希表中存储键和值  |
# ==========================
#
h = {}
h[:a] = 1       # h is now {:a=>1}
h.store(:b, 2)  # h is now {:a=>1, :b=>2}

# 替换哈希中全部键值对
h.replace({1=>:a,2=>:b})  # h is now {1=>:a, 2=>:b}

# 把两个哈希表合成一个
# Merge hashes h and j into new hash k.
# If h and j share keys, use values from j 
k = h.merge(j)
{:a=>1, :b=>2}.merge(:a=>3, :c=>3)  # => {:a=>3, :b=>2, :c=>3}
h.merge!(j)   # modifies h in place.

# If there is a block , use it to decide which value to use 
h.merge!(j) {|key,h,j| h }        # Use value from h 
h.merge(j)  {|key,h,j| (h+j)/2 }  # Use average of two values 

# update is synonym for merge!
h = {a:1, b:2}
h.update(b:4, c:9) {|key,old,new| old } # h is now {a:1, b:2, c:9}
h.update(b:4, c:9)  # h is now {a:1, b:4, c:9}

# ------------------------------------------------------------------------------
#
# ====================
# |  删除哈希表条目  |
# ====================
#
h = {:a => 1, :b => 2}
h[:a] = nil     # h now holds {:a => nil, :b => 2}
h.include? :a   # => true 
h.delete :b     # => 2
h.include? :b   # => false 
h.delete :b     # => nil 
# Invoke block if key not found 
h.delete(:b) {|b| raise IndexError, k.to_s }  # IndexError! 

h = {:a=>1, :b=>2, :c=>3, :d=>"four"}
h.reject! {|k,v| v.is_a? String }   # => {:a=>1, :b=>2, :c=>3}
h.delete_if {|k,v| k.to_s < 'b' }   # => {:b=>2, :c=>3}
h.reject! {|k,v| k.to_s < 'b' }     # => nil: no change 
h.delete_if {|k,v| k.to_s}          # => {:b=>2, :c=>3}: unchanged hash 
h.reject {|k,v| true}               # => {}: h is unchanged 

# 删除全部键值对
h.clear   # h is now {}

# ------------------------------------------------------------------------------
#
# ======================
# |  从哈希表获得数组  |
# ======================
#
h = { :a=>1, :b=>2, :c=>3 }
# Size of hash: number of key/value pairs 
h.length    # => 3
h.size      # => 3
h.empty?    # => false 
{}.empty?   # => true 

h.keys      # => [:b,:c,:a]
h.values    # => [2,3,1]
h.flatten   # => [:a, 1, :b, 2, :c, 3]
h.sort      # => [[:a,1], [:b,2], [:c,3]]
h.sort {|a,b| a[1] <=> b[1] }
  
# ------------------------------------------------------------------------------
#
# ==================
# |  哈希表迭代器  |
# ==================
#
h = { :a=>1, :b=>2, :c=>3 }

# The each iterator iterates [key,value] pairs 
h.each {|pair| print pair }   # Prints "[:a,1][:b,2][:c,3]"

# It also works with two block arguments 
h.each do |key, value|
  print "#{key}:#{value}"
end 

# Iterator over keys or values or both 
h.each_key {|k| print k }
h.each_value {|v| print v }
h.each_pair {|k,v| print k,v }

# shift 
h = { :a=>1, :b=>2 }
print h.shift[1] until h.empty?

# ------------------------------------------------------------------------------
# 
# ============
# |  默认值  |
# ============
#
empty = {}
empty["one"]    # nil 

empty = Hash.new(-1)    # Specify a default value when creating hash 
empty["one"]            # => -1
empty.default = -2      # Change the default value to something else 
empty["two"]            # => -2
empty.default           # => -2

# If the key is not defined, return the successor of the key.
plus1 = Hash.new {|hash,key| key.succ }
plus1[1]      # 2
plus1["one"]  # "onf"
plus1.default_proc    # Returns the proc that computes defaults 
plus1.default(10)     # => 11

# 使用代码块进行惰性求值
# This lazily initialized hash maps integers to their factorials 
fact = Hash.new {|h,k| h[k] = if k>1: k*h[k-1] else 1 end }
fact      # => {}
fact[4]   # => 24
fact      # => {1=>1, 2=>2, 3=>6, 4=>24}

# ------------------------------------------------------------------------------
#
# ============
# |  哈希码  |
# ============
#
# 哈希对象使用eql?方法来判定主键的相等性。
# 在1.9中，可以对哈希对象调用compare_by_identity方法，
# 强制使用equal?方法判定主键的相等性。
# hash方法将使用object_id作为哈希码。
# compare_by_identity?判断方法可以判断一个哈希对象是使用相等性(equality)，
# 还是标识符(identity)进行比较。
# 两个具有相同字符的符号字面量将被求值为相同的对象，
# 当时具有相同字符的字符串字面量将被求值为不同的对象，
# 因此符号字面量在作为主键时，可以用标识符进行比较，而字符串则不行。
#
# 如果使用了可变对象主键，并且修改了其中一个对象，你就必须调用哈希对象的rehash
# 方法。
key = {:a=>1}   # This hash will be a key in another hash!
h = {key => 2}  # This hash has a mutable key 
h[key]          # => 2
key.clear       # Mutate the key 
h[key]          # => nil 
h.rehash        # Fix up the hash after mutation 
h[key]          # => 2: It's ok!

# ------------------------------------------------------------------------------
#
# ==============
# |  杂项方法  |
# ==============
#
# invert
# ~~~~~~
# 哈希对象键值转换
h = {:a=>1, :b=>2}
h.invert    # => {1=>:a, 2=>:b}

# to_s,inspect
# ~~~~~~~~~~~~
# 转换为字符串
{:a=>1, :b=>2}.to_s
{:a=>1, :b=>2}.inspect 

# ------------------------------------------------------------------------------

