# =================
# |  闭包closure  |
# =================
#
# proc和lambda都是闭包，
# 闭包就是一个能包住变量值的函数对象，它所包住的函数值称为闭包的绑定binding。
#
# Return a lambda that retains or "closes over" the argument n
def multiplier(n)
  lambda {|data| data.collect{|x| x*n} }
end
doubler = multiplier(2)                     # Get a lambda that knows how to double
puts doubler.call([1,2,3])                  # Prints 2,4,6

# Return a pair of lambdas that share access to a local vairable.
def accessor_pair(initialValue=nil)
  value = initialValue                      # A local vairable shared by the returned lambdas.
  getter = lambda{value}                    # Return value of local vairable.
  setter = lambda{|x| value=x}              # Change value of local vairable.
  return getter, setter                     # Return pair of lambdas to caller.
end
# Useage:
# getX, setX = accessor_pair(0)
# puts getX[]
# setX[10]
# puts getX[]

# Return an array of lambdas that multiply by the arguments
def multipliers(*args)
  x = nil 
  args.map {|x| lambda{|y| x*y} }
end
# Useage:
# double, triple = multipliers(2, 3)
# puts double.call(2)
-----------------------------------------------------------------------------------------------------------------------------------------------------
# 
# =======================
# |  闭包和绑定binding  |
# =======================
# 
# Proc定义了一个binding方法，调用这个方法返回一个Binding对象，表示该闭包使用的绑定
# 使用Binding对象和eval方法可以让我们获得一个操控闭包行为的后门
def multiplier(n)
  lambda {|data| data.collect{|x| x*n} }
end
doubler = multiplier(2)                     # Get a lambda that knows how to double
puts doubler.call([1,2,3])                  # Prints 2,4,6
# 改变doubler的行为
eval("n=3", doubler.binding)                # Or doubler.binding.eval("n=3") in Ruby1.9
#
# eval还可以直接传递Proc对象 
eval("n=3", doubler)

# Kernel.binding方法也可以返回一个Binding对象，它表示调用此方法时的那些绑定
-----------------------------------------------------------------------------------------------------------------------------------------------------
