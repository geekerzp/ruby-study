# 使用raise抛出异常，使用rescue捕获异常
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 定义新的异常类
# ~~~~~~~~~~~~~~
class MyError < StandardError; end

raise
如果调用raise的时候没有实参，则创建一个新的RuntimeError对象并将其抛出
如果在一个rescue从句里不带实参的调用raise，那么它简单的将正在处理的对象重新抛出
如果以一个Exception对象作为实参来调用raise，那么它抛出异常
如果以一个字符串实参来调用raise，那么它创建一个新的RuntimeError异常对象，将指定的字符串作为该异常对象的消息并且将其抛出
如果传递给raise的第一个实参是一个具有exception方法的对象，那么raise调用exception方法并且将其返回的异常对象抛出
    可选的第二个字符串参数会被传递给exception方法，用作异常消息
    可选的第三个数组参数可以自定义轨迹栈

def factorial(n)                                                          # Define a factorial method with argument n
  raise "bad argument" if n < 1                                           # Raise an exception for bad n
# raise ArgumentError, "Expected argument >= 1. Got #{n}" if n < 1
  raise TypeError, "error argument type" if not n.is_a? Integer
  return 1 if n == 1                                                      # factorial(1) is 1
  n * factorial(n-1)                                                      # Compute other factorials recursively
end
等价于
raise RuntimeError, "bad argument" if n < 1
raise RuntimeError.new("bad argument") if n < 1
raise RuntimeError.exception("bad argument") if n < 1
#-----------------------------------------------------------------------------------------------------------------------------------------------------
# rescue从句基本用法
# ~~~~~~~~~~~~~~~~~~
全局变量$i引用了当前正在处理的Exception对象
require 'English'后，可用$ERROR_INFO来代替$i

rescue从句默认可处理任何属于StandardError的异常
通用形式为定义异常类型
rescue Exception                        # 可以处理任何异常
rescue ArgumentError => e               # 可以处理ArgumentError，并将异常对象赋值给e
rescue ArgumentError,TypeError          # 可以处理ArgumentError,TypeError，并将异常对象赋值给error

begin
  x = factorial(1)
rescue ArgumentError => ex 
  puts "Try again with a value >= 1"
rescue TypeError => ex 
  puts "Try again with an integer"
end
#-----------------------------------------------------------------------------------------------------------------------------------------------------
# rescue异常传播
# ~~~~~~~~~~~~~~
def explode                           # This method raises a RuntimeError 10% of the time
  raise "bam!" if rand(10) == 0
end

def risky
  begin                               # This block
    10.times do                       # contains another block
      explode                         # that might raise an exception.
    end                               # No rescue clause here, so propagate out.
  rescue TypeError                    # This rescue clause cannot handle a RuntimeError..
    puts $i                           # so skip it and propagate out.
  end
  "hello"                             # This is the normal return value, if no exception occurs.
end                                   # No rescue clause here, so propagate up to caller.

def defuse
  begin                               # The following code may fail with an exception.
    puts risky                        # Try to invoke print the return value.
  rescue RuntimeError => e            # If we get an exception
    puts e.message                    # print the error message instead.
  end
end

defuse
一直向上传播，一直到捕获它的rescue从句
-----------------------------------------------------------------------------------------------------------------------------------------------------
rescue从句中的retry
用于从短暂的故障中重复执行，例如网络故障中重复执行
require 'open-uri'

tries = 0                             # How many times have we tried to read the URL
begin                                 # This is where a retry begins
  tries += 1                          # Try to point out the contains of a URL
  open('http://www.163.com') {|f|
    puts f.readlines
  }
rescue OpenURI::HTTPError => e        # If we get an HTTP error
  puts e.message                      # Print the error message
  if (tries < 4)                      # If we haven't tried 4 times yet...
    sleep(2**tries)                   # Wait for 2,4, or 8 seconds
    retry                             # And then try again!
  end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------
begin
...
rescue
...
else
...
如果发生异常，执行rescue
如果没有发生异常，执行else
-----------------------------------------------------------------------------------------------------------------------------------------------------
ensure
ensure保证begin代码块中，break，next，return控制流程转移之前或rescue异常处理之后的必要执行
-----------------------------------------------------------------------------------------------------------------------------------------------------
rescue语句修饰符
如果第一个语句发生了异常，那么执行rescue之后的语句
# Compute factorial of x, or use 0 if the method raises an exception
y = factorial(x) rescue 0
-----------------------------------------------------------------------------------------------------------------------------------------------------
异常继承关系
============
  Exception
      |
      |--------- fatal (used internally by Ruby)
      |--------- NoMemoryError
      |--------- ScriptError
      |           |----- LoadError
      |           |----- NotImplementedError
      |           |----- SyntaxError
      |--------- SignalExecption
      |           |----- Interrupt
      |--------- StandardError
      |           |----- ArgumentError
      |           |----- IOError
      |           |       |--- EOFError
      |           |----- IndexError
      |           |----- LocalJumpError
      |           |----- NameError
      |           |       |--- NoMethodError
      |           |----- RangeError
      |           |       |--- FloatDomainError
      |           |----- RegexpError
      |           |----- RuntimeError
      |           |----- SecurityError
      |           |----- SystemCallError
      |           |       |--- system-dependent exceptions (Error::xxx)
      |           |----- ThreadError
      |           |----- TypeError
      |           |----- ZeroDivisionError
      |--------- SystemExit
      |--------- SystemStackError
  



