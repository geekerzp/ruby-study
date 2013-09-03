# 模块可以作为命名空间(namespace)和混入(mixin)使用
# 就像类对象时Class类的实例一样，模块对象也是Module类的一个实例，Class类继承了Module类
# 所有的类都是模块，并非所有的模块都是类
#
# 模块用于命名空间
module Base64
  DIGTS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  
  class Encoder
    def encode 
    end
  end

  class Decoder
    def decode 
    end 
  end

  def Base64.helper
  end
end
#
# 模块用于混入
# 第一种混入方式 include 
module Iterable   # Classes that define next can include this module
  include Enumerable          # Define iterators on top of each 
  def each                    # And define each on top of next 
    loop { yield self.next }
  end 
end 
# 第二种混入方式 extend 
countdown = Object.new        # A plain old object 
def countdown.each            # The each iterator as a singleton method 
  yield 3
  yield 2
  yield 1
end 
countdown.extend(Enumerable)  # Now the onject has all Enumerable methods 
print countdown.sort          # Print "[1, 2, 3]"

