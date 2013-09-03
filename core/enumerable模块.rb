#
# ====================
# |  Enumerable模块  |
# ====================
#
# 1.each
# ~~~~~~
# 每个混入Enumerable模块的类必须定义each方法。
#
# 2.each_with_index
# ~~~~~~~~~~~~~~~~~
# 它接受一个集合元素和一个整数，
# 对于数组，这个整数是数组的索引，
# 对于IO，它是行号，
# 对于其它对象，它是该集合元素转化为数组后的索引。
#
# 3.cycle
# ~~~~~~~
# 无限循环，直到出现break,return或抛出异常，
# 在对enumerable对象进行第一次迭代时，cycle把所有元素存储在一个数组中，
# 以后的迭代在数组中进行。  
#
# 4.each_slice,each_cons
# ~~~~~~~~~~~~~~~~~~~~~~
# each_slice(n)在n个元素“切片”上对集合进行迭代。
(1..10).each_slice(4) {|x| print x }  # => [1,2,3,4],[5,6,7,8],[9,10]
# each_cons类似，不过它在集合上使用“滑动窗口”的方式迭代。
(1..5).each_cons(3) {|x| print x }    # => [1,2,3],[2,3,4],[3,4,5]
#
# 5.map,collect
# ~~~~~~~~~~~~~
# 把指定代码块应用到集合的每个元素上，并把所有代码块的返回值集合到一个数组中。
# map是collect的同义词。
data = [1,2,3,4]
roots = data.map {|x| Math.sqrt x }
words = %w[ hello world ]             # %w: 用来生成数组
upper = words.collect {|x| x.upcase }
#
# 5.zip 
# ~~~~~
# 对一个集合用其他的零个或多个集合进行插值，并把每组元素迭代给相关代码块，
# 如果没有相关代码块，则返回一个数组的数组。
(1..3).zip([4,5,6]) {|x| print x.inspect }  # => [1,4],[2,5],[3,6]
(1..3).zip([4,5,6],[7,8]) {|x| print x }    # => [1, 4, 7][2, 5, 8][3, 6, nil]
(1..3).zip('a'..'z')                        # => [[1,'a'],[2,'b'],[3,'c']]
#
# 6.to_a
# ~~~~~~
# 将可枚举的集合转化为数组。
(1..3).to_a   # => [1,2,3]
#
# 7.sort 
# ~~~~~~
w = Set['apple', 'Beet', 'carrot']  # A set of words to sort 
w.sort                              # ["Beet", "apple", "carrot"]:alphabetical
w.sort {|a,b| b<=>a }               # ["carrot", "apple", "Beet"]:reverse
w.sort {|a,b| a.casecmp(b) }        # ["apple", "Beet", "carrot"]:ignore case 
w.sort {|a,b| a.size<=>b.size }     # ["Beet", "apple", "carrot"]:length

# Case-insensitive sort
words = ['carrot', 'Beet', 'apple']
words.sort_by {|x| x.downcase }     # => ['apple', 'Beet', 'carrot']
#
# 7.include?,member?
# ~~~~~~~~~~~~~~~~~~
# 判断集合是否包含某个元素
primes = Set[2,3,4,5]
primes.include? 2
primes.member? 1 
#
# 8.find,detect,find_index
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# find返回块执行结果为真的第一个元素，
# detect为find的同义词，
# find_index返回第一个块执行结果为真的元素的索引。
#
# Find the first subarray that includes the number 1
data = [[1,2], [0,1], [7,8]]
data.find {|x| x.include? 1 }   # => [1,2]
data.detect {|x| x.include? 3 } # => nil 
#
# 9.find_all,select
# ~~~~~~~~~~~~~~~~~
# select返回块执行结果为真的所有元素，
# find_all为select的同义词。
#
(1..8).select {|x| x%2 == 0 }
(1..8).select {|x| x%2 == 1 }
# 
# 10.reject
# ~~~~~~~~~
# reject返回块执行结果为假的所有元素。
#
primes = [2,3,5,7]
primes.reject {|x| x%2 == 0 }   # => [3,5,7]
#
# 11.partition
# ~~~~~~~~~~~~
# 将块执行结果为真和为假做为两个数组返回。
(1..8).partition {|x| x%2 == 0 }
#
# 12.group_by
# ~~~~~~~~~~~
# 把代码块执行的结果作为哈希表的主键使用，
# 所有返回值等于主键的元素构成一个数组，作为该主键的值。
#
# Group programming languages by their first letter 
langs = %w[ java perl python ruby ]
groups = langs.group_by {|lang| lang[0] }
groups    # => {"j"=>["java"], "p"=>["perl", "python"], "r"=>["ruby"]}
#
# 13.grep
# ~~~~~~~
# grep返回一个所有匹配给定参数的元素的数组，
# 决定成功与否的方法是参数的条件相等性比较符(case equality operator, ===)。
#
langs = %w[ java perl python ruby ]
langs.grep(/^p/)                      # => ["perl", "python"]
langs.grep(/^p/) {|x| x.capitalize }  # => ["Perl", "Python"]
data = [1, 17, 3.0, 4]
ints = data.grep(Integer)             # => [1,17,4]
small = data.grep(1..9)               # => [1, 3.0, 4]
#
# 14.first,take,drop,take_while,drop_while
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# first返回Enumerable对象的第一个元素，如果给定一个整型参数n，则返回一个包含前n
# 个元素的数组。
p (1..5).first(2)   # [1,2]

# take返回Enumerable对象前面n个元素构成的数组。
p (1..5).take(3)    # [1,2,3]

# drop返回除了前面n个元素外所有元素构成的数组。 
#
p (1..5).drop(3)    # [4,5]

# take_while把Enumerable对象依次传给代码块，直到代码块返回false或nil为止，
# 然后前面返回值为真的元素形成一个数组作为方法的返回值。
[1,2,3,nil,4].take_while {|x| x }   # => [1,2,3]: take until nil 

# drop_while把Enumerable对象依次传给代码块，直到代码块返回false或nil为止，
# 然后返回为假的元素以及后面所有的元素形成的一个数组。
[nil,1,2].drop_while {|x| x !x }    # => [1,2]: drop leading nils 
#
# 15.min,max,min_by,max_by  
# ~~~~~~~~~~~~~~~~~~~~~~~~
[10, 100, 1].min    # => 1
['a', 'b', 'c'].max # => 'c'
[10, 'a', []].max   # => ArgumentError: elements not comparable 

langs = %w[java perl python ruby]
langs.max {|a,b| a.size <=> b.size }  # => "python" 
langs.max_by {|word| word.length }    # => "python"
#
#
# 16.minmax,minmax_by 
# ~~~~~~~~~~~~~~~~~~~
(1..100).minmax                   # => [1,100]
(1..100).minmax_by {|n| n.to_s }  # => [1,99]

    
# 17.all?,none?,any?,one?
# ~~~~~~~~~~~~~~~~~~~~~~~
# all?在所有元素为真时返回真，
# any?在有一个元素为真时返回真，
# one?在只有一个元素为真时返回真，
# none?在没有一个元素为真时返回真。
#
c = -2..2
c.all? {|x| x>0 }   # => false 
c.any? {|x| x>0 }   # => true 
c.none? {|x| x> 2}  # => true 
c.one? {|x| x>0 }   # => false 
c.one? {|x| x>2 }   # => false 
c.one? {|x| x==2}   # => true 
[1,2,3].all?        # => true 
[nil,false].any?    # => false 
[].none?            # => true 


# 18.count
# ~~~~~~~~
# 返回集合中等于给定值元素的个数，或者是关联代码块返回真的元素的个数。
#
a = [1,1,2,3,5,8]
a.count(1)              # => 2: two elements equal 1 
a.count {|x| x%2 == 1}  # => 4: four elements are odd 


# 19.inject,reduce  
# ~~~~~~~~~~~~~~~~
# reduce为inject的别名，
# inject关联的代码块需要两个参数，第一个是一个累积值，第二个是集合中的元素，
# 在第一次迭代中，inject方法的参数被传给累积值，代码块的返回值成为下次迭代的
# 累积值，最后一个迭代的返回值成为inject方法的返回值。
#
# How many negative numbers?
(-2..10).inject(0) {|num,x| x<0? num+1 : num }    # => 2
# Sum of word length
%w[pea queue are].inject(0) {|total, world| total+word.length }
#
# 如果在调用inject时不带参数，那么在第一次调用时，集合的头两个元素被传递给
# 代码块。
sum = (1..5).inject {|total, x| x + total }   # => 15
prod = (2..6).inject {|total, x| x * total }  # => 720
[1].inject {|total,x| total + x }             # => 1: block never called
sum = (1..5).reduce(1, :+)
prod = (2..6).reduce(1, :*)
#
# ------------------------------------------------------------------------------

