#  
# ==================
# |  两种Proc对象  |
# ==================
proc        块对象
lambda      函数对象
# ------------------------------------------------------------------------------
#
# ==============
# |  proc对象  |
# ==============
# 
# 1.通过方法调用来创建proc对象
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This method creates a proc from a block
def makeproc(&p)        # Convert associated block to a Proc and store in p
  p                     # Return the proc object
end 

# Usage:
  adder = makeproc {|x,y| x + y }

# 2.通过Proc.new来创建
# ~~~~~~~~~~~~~~~~~~~~
Proc.new
p = Proc.new {|x,y| x + y}

# 3.通过Kernel.proc来创建
# ~~~~~~~~~~~~~~~~~~~~~~~
p = proc {|x,y| x + y}
# ------------------------------------------------------------------------------
# 
# ================
# |  lambda对象  |
# ================
#
# 1.Lambda的历史
# ~~~~~~~~~~~~
# Lambda和lambda方法的名字来自lambda演算，它是数理逻辑的一个分支，
# 被应用到函数式编程语言中。
# Lisp也使用术语lambda来表示可以被当作对象操作的函数。

# 2.创建lambda对象
# ~~~~~~~~~~~~~~~~
# 1.8
succ = lambda {|x| x+1 }
# 1.9
succ = ->(x) { x+1 }

# 3.lambda局部块变量
# ~~~~~~~~~~~~~~~~
f = ->(x,y; i,j,k) {...}

# 4.lambda参数默认值
# ~~~~~~~~~~~~~~~~
zoom = ->(x,y,factor=2) { [x*factor, y*factor] }

# 5.省略写法
# ~~~~~~~~
succ = ->x { x+1 }
f = ->x,y; i,j,k {...}
zoom = ->x,y,factor=2 { [x*factor, y*factor] }

# 6.lambda作为方法参数
# ~~~~~~~~~~~~~~~~~~
def compose(f,g)                                # Compose 2 lambdas
  ->(x) { f.call(g.call(x)) }
end 
succOfSquare = compose(->x{x+1}, ->x{x*x})
succOfSquare.call(4)                            # => 17: Computes (4*4)+1
# ------------------------------------------------------------------------------
# 
# ====================
# |  Proc相等性判断  |
# ====================
#
# Proc类使用==来判断两个Proc对象是否相等，
# 当一个Proc对象是另一个Proc对象的clone或duplicate时，
# 或者是同一个对象的引用时，会返回true
# 两个块相同的lambda/proc对象不相等
lambda {|x| x*x } == lambda {|x| x*x }          # => false
# ------------------------------------------------------------------------------
# 
# ========================
# |  lambda和proc的区别  |
# ========================
#
# 1.区别
# ~~~~~~
# proc: proc为函数的代码块。
# lambda：lambda为匿名函数。
#
# 2.区别方法
# ~~~~~~~~~~
# Proc对象的实例方法lambda?来判断该实例是一个Proc还是lambda 
# ------------------------------------------------------------------------------
#
# ================
# |  return语句  |
# ================
#
# 1.proc从所在的方法返回
# ~~~~~~~~~~~~~~~~~~~~~~
# 在proc被调用时，在句法上包含该proc的方法已经返回，所以会抛出LocalJumpError异常。

def procBuilder(message)                          # Create and return a proc
  Proc.new { puts message; return }               # return returns from procBuilder
  # but procBuilder has already returned here!
end
def test
  puts "entering method"
  p = procBuilder("entering proc");
  p.call                                          # Prints "entering proc" and raises LocalJumpError
  puts "exiting method!"                          # This line is never executed
end
test 

# 2.lambda从自身代码块返回
# ~~~~~~~~~~~~~~~~~~~~~~~~
# lambda中的return仅仅从lambda自身代码块返回，无须考虑LocalJumpError。

def lambdaBuilder(message)                        # Create and return a lambda
  lambda { puts message; return }                 # return returns from the lambda
end
def test 
  puts "entering method"
  l = lambdaBuilder("entering lambda")
  l.call                                          # Prints "entering lambda"
  puts "exiting method"                           # This line is executed
end
test
# ------------------------------------------------------------------------------
# 
# ===============
# |  break语句  |
# ===============
#
# 1.proc从代码返回到它的迭代器，然后该迭代器再返回到调用它的方法
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 当我们用Proc.new创建一个proc时，这个Proc.new就是break语句应该返回的地方，
# 当我们调用proc对象时，这个迭代器已经返回了。

def test
  puts "entering test method"
  proc = Proc.new { puts "entering proc"; break }
  proc.call                                       # LocalJumpError: iterator has already returned
end
test

# 如果通过迭代器方法的&参数创建一个proc，我们可以调用它让该迭代器方法返回 

def iterator(&proc)
  puts "entering iterator"
  proc.call                 # invoke the proc
  puts "exiting iterator"   # Never executed if the proc breaks
end
def test 
  iterator { puts "entering proc"; break; }
end 

# 2.lambda从自身代码块返回
# ~~~~~~~~~~~~~~~~~~~~~~~~

def test 
  puts "entering test method"
  lambda = lambda { puts "entering lambda"; break; puts "exiting lambda" }
  lambda.call
  puts "exiting test method"
end
# ------------------------------------------------------------------------------
# 
# ==============
# |  next语句  |
# ==============
#
# 在代码块，proc，lambda中从yield或call返回
# ------------------------------------------------------------------------------
# 
# ==============
# |  redo语句  |
# ==============
#
# 它让控制流程转向该lambda或proc的开始处 
# ------------------------------------------------------------------------------
# 
# ===============
# |  retry语句  |
# ===============
# 
# 禁止使用，抛出LocalJumpError异常
# ------------------------------------------------------------------------------
# 
# ===============
# |  raise语句  |
# ===============
# 
# 异常向调用栈的上层传播
# ------------------------------------------------------------------------------













