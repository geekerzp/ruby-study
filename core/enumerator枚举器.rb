#
# ============================
# |  作为Enumerable代理对象  |
# ============================
#
# Enumerator对象具有each方法的Enumerable对象，这个each方法建立在其他对象的某个
# 迭代器方法上。
#
# 获得方法
# ~~~~~~~~
# 1.通过Object类的to_enum(enum_for)获得一个枚举器
#
# 调用数组的to_enum方法获得一个可枚举但不可变的代理对象传递给一个方法
# Call this method with an Enumerator instead of a mutable array.
# This is a useful defensive strategy to avoid bugs.
process(data.to_enum) # Instead of just process(data)
也可以使用
process(data.each)

# Ruby1.9中String类不是Enumerable的，但是它具有三个迭代器方法：each_char,each_byte,each_line
# 假如我们想使用一个Enumerable方法map，基于each_char迭代器，则
s = "hello"
s.enum_for(:each_char).map { |c| c.succ }   # => ["i", "f", "m", "m", "p"]

# 2.当以不带代码块的方式调用Ruby1.9所内建的迭代器方法时，自动返回一个枚举器
"hello".chars.map { |c| c.succ }
enumerator = 3.times      # An enumerator Object
enumerator.each {|x| print x }
# downto returns an enumerator with a select method
10.downto(1).select {|x| x%2 == 0 }
# each_byte iterator returns an enumerator with a to_a method
"hello".each_byte.to_a

# 自定义迭代器方法返回枚举器
def twice
  if block_given?
    self.each {|x| yield x }
    self.each {|x| yield x }
  else 
    self.to_enum(:twice)
  end
end

# 无论是Ruby1.8,1.9,迭代器都是一些可被用于for循环的Enumerable对象
for line, number in text.each_line.with_index     
  # with_index返回的是一个带索引的枚举器
  print "#{number+1}: #{line}"
end
#
# ------------------------------------------------------------------------------
#
# ====================
# |  作为外部迭代器  |
# ====================
#
# 迭代器方法在没有调用块的情况下返回一个枚举器，
# 调用next方法可获集合的内部元素，直到抛出StopIteration异常，
# 然后自动开始下一个迭代循环。 
"Ruby".each_char.max      # => "y": Enumerable method of Enumerator
iter = "Ruby".each_char   # Create an Enumerator
loop { print iter.next }  # Prints "Ruby"; use it as external iterator 
print iter.next           # Prints "R"; iterator restarts automatically 
iter.rewind               # Force it to restart now 
print iter.next           # Prints "R" again














