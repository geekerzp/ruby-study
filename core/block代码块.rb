#
# ==================
# |  代码块的用法  |
# ==================
#
# 1. 作为内部迭代器
# ~~~~~~~~~~~~~~~~~
[1, 3, 5, 7].inject(0) {|sum, element| sum + element }
[1, 3, 5, 7].inject(1) {|project, element| project * element }

# 2. 实现事务blocks
# ~~~~~~~~~~~~~~~~~
# block可以用来定义必须在事务控制环境下的代码。
class File
  def File.open_and_process(*args)
    f = File.open(*args)
    yield f
    f.close 
  end 
end 

File.open_and_process("testfile", "r") do |file|
  while line = file.gets
    puts line 
  end 
end 

# 3. 作为闭包(closure)
# ~~~~~~~~~~~~~~~~~~~~
def n_times(thing)
  return lambda {|n| n * thing }
end 

p1 = n_times(3)
p1.call(22)     # => 66
p2 = n_times(4)
p2.call(22)     # => 88
