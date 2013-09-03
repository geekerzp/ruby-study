枚举器Enumerator可作为外部迭代器使用
iterator = 9.down(1)              # 获取一个枚举器Enumerator,An enumerator as external iterator
begin                             # So we can use rescue below
  print iterator.next while true  # Call the next method repeatedly
rescue  StopIteration             # When there are no more values
  puts "...blastoff!"             # An expected, nonexceptional condition
end

如果重新调用底层Enumerable对象的each方法不能使其重新开始一个迭代，那么调用rewind方法也不会奏效

克隆或复制外部迭代器的时机为
next被调用之前
StopIteration被抛出之后
rewind被调用之后

将实现了next的外部迭代器转换为实现each的内部迭代器
module Iterable
  include Enumerable
  def each
    loop { yield self.next }
  end
end

将一个外部迭代器传递给一个内部迭代器
def iterable(iterator)
  loop { yield iterator.next }
end 

iterable(9.downto(1)) {|x| print x }
  
  
