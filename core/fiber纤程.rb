Fiber纤程的原理
Fiber.new来创建一个纤程，并且给它一个代码块来指定需要执行的代码
一个纤程的代码体不会立刻被执行，需要调用那个纤程的Fiber对象的resume方法来开始纤程的运行
在第一次调用一个纤程的resume方法时，程序控制权被传递到纤程体的起始部分,然后纤程开始运行
直到运行完整个纤程体或遇到Fiber.yield这个类方法为止
Fiber.yield方法把程序控制权传回给调用者，使得对resume的调用返回
它还将保存纤程的状态，这样一来当下次调用resume方法时，该纤程就可以从上次离开的地方开始运行
纤程不像线程，不会并行执行，调用者会阻塞一直到纤程yield返回，是协同例程，本质上是半协同例程
线程间具有调度器，可以自动调度并行执行，纤程不具有调度器许需要通过transfer方法显示的调度自己
-----------------------------------------------------------------------------------------------------------------------------------------------------
Fiber纤程的创建
f = Fiber.new {
  puts "Fiber says hello"
  Fiber.yield
  puts "Fiber says googbye"
}

puts "Caller says hello"
f.resume
puts "Caller says googbye"
f.resume

OUTPUT:
Caller says hello
Fiber says hello
Caller says googbye
Fiber says googbye
-----------------------------------------------------------------------------------------------------------------------------------------------------
Fiber纤程间的参数传递
第一次调用resume时实参将被传递给与该纤程相关的代码块，它们成为代码形参的值
在后续调用中，resume的实参值将成为Fiber.yield的返回值
Fiber.yield的实参值将成为resume的返回值
f = Fiber.new do |message|
  puts "Caller said: #{message}"
  message2 = Fiber.yield("hello")
  puts "Caller said: #{message2}"
  "Fine"
end

response = f.resume("Hello")
puts "Fiber said: #{response}"
response2 = f.resume("How are you?")
puts "Fiber said: #{response2}"
-----------------------------------------------------------------------------------------------------------------------------------------------------
用Fiber纤程实现生成器Generator
# Return a Fiber to compute Fibonacci numbers
def fibonacci_generator(x0,y0)                # Base the sequence on x0, y0
  Fiber.new do                                 
    x,y = x0,y0                               # Initialize x and y
    loop do                                   # This Fiber runs forever
      Fiber.yield y                           # Yield the next number in sequence
      x,y = y,x+y                             # Update x,y
    end
  end
end

g = fibonacci_generator(0, 1)                 # Create a generator
10.times { print g.resume, " " }              # And use it
-----------------------------------------------------------------------------------------------------------------------------------------------------
Fiber高级特性
纤程间通过transfer显式的调度自己
require 'fiber'
f = g = nil
f = Fiber.new {|x|
  puts "f1: #{x}"
  x = g.transfer(x+1)
  puts "f2: #{x}"
  x = g.transfer(x+1)
  puts "f3: #{x}"
  x+1
}
g = Fiber.new {|x|
  puts "g1: #{x}"
  x = f.transfer(x+1)
  puts "g2: #{x}"
  x = f.transfer(x+1)
}
puts f.transfer(1)

firber库还定义了alive?的实例方法来检测一个纤程是否还在运行
current的类方法，用于返回当前掌握控制权限的Fiber对象

