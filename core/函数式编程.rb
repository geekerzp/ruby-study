函数式编程计算标准差
# Compute the average and standard deviation of an array numbers
a = [1,2,3,4,5,6,7,8,9,10]
mean = a.inject {|x,y| x+y } / a.size
sumOfSquares = a.map {|x| (x-mean)**2 }.inject {|x,y| x+y}
standardDeviation = Math.sqrt(sumOfSquares/(a.size-1))
-----------------------------------------------------------------------------------------------------------------------------------------------------
对一个Enumerable对象应用一个函数

# This module defines methods and operators for functional programming. 
module Functional

  # Apply this function to each element of the specified Enumerable.
  # returning an array of results. This is the reverse of Enumerable.map. 
  # Use | as an operator alias. Read "|" as "over" or "applied over". 
  #
  # Example:
  #   a = [[1,2],[3,4]]
  #   sum = lambda {|x,y| x+y }
  #   sums = sum|a    # => [3,7]
  def apply(enum)
    enum.map &self
  end
  alias | apply

  # Use this function to "reduce" an enumerable to a single quantity.
  # This is the inverse of Enumerable.inject. 
  # Use <= as an operator alias.
  # Mnemonic: <= looks like a needle for injections 
  # Example:
  #   data = [1,2,3,4]
  #   sum = lambda {|x,y| x+y}
  #   total = sum<=data   # => 10 
  def reduce(enum)
    enum.inject &self
  end
  alias <= reduce
end

# Add these functional programming methods to Proc and Method classes.
class Proc; include Functional; end
class Method; include Functional; end 

a = [1,2,3,4,5,6,7,8,9,10]
sum = lambda {|x,y| x+y }
mean = (sum<=a)/a.size
deviation = lambda {|x| x-mean }
square = lambda {|x| x*x }
standardDeviation = Math.sqrt((sum<=square(deviation|a))/(a.size-1))
-----------------------------------------------------------------------------------------------------------------------------------------------------
复合函数 
module Functional
  # Return a new lambda that computes self[f[args].
  # Use * as an operator alias for compose.
  # Examples, using the * alias for this method.
  #
  # f = lambda {|x| x*x }
  # g = lambda {|x| x+1 }
  # (f*g)[2]    # => 9
  # (g*f)[2]    # => 5
  #
  #
  def compose(f)
    if self.respond_to?(:arity) && self.arity == 1
      lambda {|*args| self[f[*args]] }
    else 
      lambda {|*args| self[*f[*args]]}
    end
  end 

  # * is the natural operator for function composition.
  alias * compose 
end 

使函数复合
standardDeviation = Math.sqrt ((sum<=square*deviation|a)/(a.size-1))
-----------------------------------------------------------------------------------------------------------------------------------------------------
局部应用函数
局部应用是指一个函数和部分参数值产生一个新的函数，这个函数等价于用某些固定参数调用原有的函数
module Functional
  #
  # Return a lambda equivalent to this one with the one or more initial
  # arguments applied. When only a single argument is being specified, the >> alias may be simpler to use. 
  #
  # Example:
  #   product = lambda {|x,y| x*y }
  #   doubler = product >> 2
  def apply_head(*first)
    lambda {|*rest| self[*first.concat(rest)]}
  end

  # 
  # Return a lambda equivalent to this one with one or more final arguments 
  # applied. When only a single argument is being specified.
  # the << alias may be simpler.
  #
  # Example:
  #   difference = lambda {|x,y| x-y }
  #   decrement = difference << 1
  #
  def apply_tail(*last)
    lambda {|*rest| self[*rest.concat(last)]}
  end

  # Here are operator alternatives for these methods. 
  # The angle brackets point to the side on which the argument is shifted in. 
  alias >> apply_head
  alias << apply_tail
end

product = lambda {|x,y| x*y }
doubler = product >> 2

difference = lambda {|x,y| x-y }
deviation = difference << mean
-----------------------------------------------------------------------------------------------------------------------------------------------------
缓存函数Memoizing
Memoizing是函数式编程的一个术语，表示缓存函数调用的结果
如果一个函数对同样的参数输入总是返回相同的结果，另外出于某种需要我们认为这些参数会不断使用
而且执行这个函数比较消耗资源，那么Memoizing可能是一个有用的优化
module Functional
  #
  # Return a new lambda that caches the results of this function and 
  # only calls the function when new arguments are supplied.
  #
  def memoize
    cache = {}    # An empty cache. The lambda captures this in its closure.
    lambda {|*args|
      # notice that the hash key is the entire array of arguments!
      unless cache.has_key?(args)     # If no cached result for these args
        cache[args] = self[*args]     # Comppute and cache the result 
      end
      cache[args]                     # Return result from cache
    }
  end
  # A (probably unnecessary) unary + operator for memoization
  # Mnemonic: the + operator means "improved"
  alias +@ memoize        #cached_f = +f
end
Usage:
缓存递归函数
# A memoized recursive factorial function
factorial = lambda {|x| return 1 if x == 0; x*factorial[x-1] }.memoize
# Or, using the unary operator syntax
factorial = +lambda {|x| return 1 if x == 0; x*factorial[x-1] }

非缓存递归函数
factorial = lambda {|x| return 1 if x == 0; x*factorial[x-1] }.memoize
cached_factorial = +factorial
-----------------------------------------------------------------------------------------------------------------------------------------------------
#
# Add [] and []= operators to the Symbol class for accessing and setting
# singletion methods of objects.
# Read : as "method" and [] as "of".
# So :m[o] reads "method m of o"
#
class Symbol
  # Return the Method of obj named by this symbol. This may be a singletion
  # method of obj (such as a class method) or an instance method defined
  # by obj.class or inherited from a superclass.
  # Example:
  #   creator = :new[Object]        # Class method Object.new 
  #   doubler = :*[2]               # * method of Fixnum 2
  #
  def [](obj)
    obj.method(self)
  end

  # Define a singletion method on object o, using Proc or Method f as its body.
  # This symbol is used as the name of the method.
  # Examples:
  #
  #   :singletion[o] = lambda { puts "this is a singletion method of o" }
  #   :class_method[String] = lambda { puts "this is a class method" }
  #
  # Note that you can't create instance method this way. 
  # See Module.[]=
  #
  def []=(o,f)
    # We can't use self in the block below, as it is evaluated in the 
    # context of a different object. So We have to assign self to a variable.
    sym = self
    # This is the object we define singletion methods on.
    eigenclass = (class << o; self end)
    # defined_method is private, so we have to use instance_eval to execute it.
    eigenclass.instance_eval { defined_method(sym, f) }
  end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------



