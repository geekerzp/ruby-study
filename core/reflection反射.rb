# =======================
# | 反射(reflection)API |
# =======================
# types,classes and modules 类型，类和模块
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
o.class 
# 返回对象o的类
o.superclass
# 返回对象o的超类
o.instance_of? c
# 判断是否o.class == c
o.is_a? c
# 判断是否是c或它某个子类的实例，如果c是模块，则这个方法判断o.class是否包含了该模块
o.kind_of? c
# is_a?的同义词
c === o
# 对于任意类或模块c，判断是否o.is_a?(c)
o.respond_to? name
# 判断对象o是否具有一个给定的公开的或保护方法，如果第二个参数设置为true，则会检查私有方法
#----------------------------------------------------------------------------------------------------------------------------------------------------
#
#ancestry and modules祖先类和模块
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module A; end               # Empty module 
module B; include A; end    # Module B includes A
class C; include B; end     # Class C includes module B

C < B                       # => true: C includes B
B < A                       # => true: B includes A
C < A                       # => true 
Fixnum < Integer            # => true: all fixnums are integers
Integer < Comparable        # => true: all integers are comparable
Integer < Fixnum            # => false: not all integers are fixnums 
String < Numeric            # => nil: strings are not numbers 

C.include?(B)               # => true 
C.include?(A)               # => true 
B.include?(A)               # => true 
A.include?(A)               # => false 
A.include?(B)               # => false  

A.included_modules          # => []
B.included_modules          # => [A]
C.included_modules          # => [B, A, Kernel]
#----------------------------------------------------------------------------------------------------------------------------------------------------
#
# Object.extend
# ~~~~~~~~~~~~~
# 把指定模块的实例方法作为调用对象的单键方法，这样就扩展了调用对象
module Greeter; def hi; "hello"; end; end     # A silly module 
s = "String Object"
s.extend(Greeter)                             # Add hi as a singleton method to s 
s.hi                                          # => "hello"
String.extend(Greeter)                        # Add hi as a class method of string 
String.hi                                     # => "hello"
#----------------------------------------------------------------------------------------------------------------------------------------------------
#
# Module.nesting
# ~~~~~~~~~~~~~~
# 指出当前代码的模块嵌套情况，与模块包含及祖先类无关
module M
  class C
    Module.nesting          # => [M::C M]
  end 
end 
#----------------------------------------------------------------------------------------------------------------------------------------------------
#
# 另一种创建模块和类的方法
# ~~~~~~~~~~~~~~~~~~~~~~~~
# 类和模块分别是Class和Module的实例 
M = Module.new      # Define a new module M 
C = Class.new       # Define a new class C
D = Class.new(C) {  # Define a subclass of C
  include M         # that includes module M
}
D.to_s              # => "D": class gets constant name by magic 
# Ruby特性: 如果把动态创建的匿名模块或类赋值给一个常量，常量的名字就成为这个模块或类的名字
#----------------------------------------------------------------------------------------------------------------------------------------------------
#
# Bindings and eval Bindings对象和eval方法
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
class Object        # Open Object to add a new method
  def bindings      # Note plural on this method
    binding         # This is the predefined Kernel method
  end 
end 

class Test          # A simple class with an instance variable 
  def initialize(x); @x = x; end
end

t = Test.new(10)        # Create a test object 
eval("@x", t.bindings)  # => 10: We've peeked inside t
#----------------------------------------------------------------------------------------------------------------------------------------------------
#
# instance_eval 和 class_eval
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Object类定义了一个instance_eval的方法，Module类定义了一个class_eval(module_eval)方法，
# 它们在指定对象或模块的上下文中对代码求值
#
o.instance_eval("@x")   # Return the value of o's instance variable @x

# Define an instance method len of String to return string length 
String.class_eval("def len; size; end")

# Here's another way to do that 
# The quoted code behaves just as if it was inside "class String" and "end"
String.class_eval("alias len size")

# Use instance_eval to define class method String.empty 
# Note that quotes within quotes get a little tricky...
String.instance_eval("def empty; ''; end")
#
# instance_eval为这个对象创建一个单键方法，如果这个对象是类，则创建一个类方法
# class_eval则定义一个普通的实例方法 
#
# instance_eval和class_eval还可以在代码块中求值
#
o.instance_eval { @x }
String.class_eval {
  def len
    size 
  end
}
String.instance_eval {
  def empty
    ''
  end 
}
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# 
# instance_exec 和 class_exec
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 类似于instance_eval和class_eval在对象的上下文中对给定的代码块进行求值，
# 同时，可以接受除接收者对象以外的方法参数
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# variables 和 constants 
# ~~~~~~~~~~~~~~~~~~~~~~
# Kernel,Object,Module定义了很多反射方法来列出各种名字，
# 包括所有定义的全局变量，当前使用的局部变量，一个对象的全部实例变量，一个类或模块的全部变量和常量
#
global_variables    # => ["$DEBUG", "$SAFE", ...]
x = 1               # Define a local variable 
local_variables     # => ["x"]

# Define a simple class 
class Point 
  def initialize(x, y); @x, @y = x, y; end    # Define instance variables
  @@classvar = 1                              # Define a class variable
  ORIGIN = Point.new(0, 0)                    # Define a constant
end

Point::ORIGIN.instance_variables              # => ["@x", "@y"]
Point.class_variables                         # => ["@@classvar"]
Point.constants                               # => ["ORIGIN"]
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# Querying Setting and Testing Variables 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 读写局部和全局变量
#
x = 1
varname = "x"
eval(varname)           # => 1
eval("varname = '$g'")  # => varname = '$g'
eval("#{varname} = x")  # => $g = 1
eval(varname)           # => 1
#
#
# 读写，检测实例变量，类变量和类常量
o = Object.new 
o.instance_variable_set(:@x, 0)   # Note required @ prefix
o.instance_variable_get(:@x)      # => 0
o.instance_variable_defined?(:@x) # true 

Object.class_variable_set(:@@x, 1)    # private in 1.8
Object.class_variable_get(:@@x)       # private in 1.8
Object.class_variable_defined?(:@@x)  # private in 1.8

Math.const_set(:EPI, Math::E*Math::PI)
Math.const_get(:EPI)      # => 8.539734222673566
Math.const_defined(:EPI)  # => true
#
# 如果const_get和const_defined?第二个参数为false，则在当前的类或模块中查找，无须考虑继承
#
# Object和Module中的一些私有方法被用来取消实例变量，类常量和常量的定义
#
o.instance_eval { remove_instance_variable :@x }
String.class_eval { remove_class_variable(:@@x) }
Math.send :remove_const, :EPI 
#
# 如果一个模块定义了const_missing方法，当找不到指定常量时，该方法将被调用
def Symbol.const_missing(name)
  name        # Return the constant name as a symbol
end   
Symbol::Test  # :Test :undefined constant evaluates to a Symbol
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# Listing and Testing For Methods
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 查询方法
#
o = "a string"
o.methods                 # => [names of all public methods]
o.public_mehods           # => the same thing 
o.public_mehods(false)    # Exclude inherited methods  
o.protected_methods       # => []: there aren't any 
o.private_methods         # => array of all private methods 
o.private_methods(false)  # Exclude inherited private methods
def o.single; 1; end      # Define a singleton method
o.singleton_methods       # => [:single]

String.instance_methods == "s".public_mehods                # => true 
String.instance_methods(false) == "s".public_mehods(false)  # => true 
String.instance_methods == String.public_instance_mehods    # => true 
String.protected_instance_methods                           # =>  []
String.private_instance_methods(false)

String.public_method_defined? :reverse      # => true 
String.protected_method_defined? :reverse   # => false 
String.private_method_defined? :initialize  # => true 
String.method_defined? :upcase!             # => true 
#
# 获取Method对象
#
# method 返回绑定于接收者的可调用Method对象
# instance_method 返回不绑定的UnboundMethod对象 
#
"s".method(:reverse)              # => Method object
String.instance_method(:reverse)  # => UnboundMethod object 
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# 
# 通过send调用方法
# ~~~~~~~~~~~~~~~~
# send来自于面向对象编程术语，在那里调用一个方法被称为向一个对象“发送一个消息”
# send是Object的私有方法
#
"hello".send :upcase          # => "HELLO": invoke an instance method 
Math.send(:sin, Math::PI/2)   # => 1.0: invoke a class method 
# 
# send可以调用一个对象的私有方法，保护方法，公开方法
# send在接收者对象上调用名为第一个参数的方法，后面的其他参数会作为调用方法的参数
# __send__是send的同义词
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# 通过define_method定义方法
# ~~~~~~~~~~~~~~~~~~~~~~~~~
# Module的私有方法
# 第一个参数是新的方法名字，第二个参数是Method对象或代码块
#
# 增加实例方法
# Add a instance method named m to class c with body b
def add_method(c, m, &b)
  c.class_eval {
    define_method(m, &b)
  }
end 

add_method(String, :greet) { "Hello, " + self }

"world".greet   # => "Hello, world"
#
# 增加类方法
def add_class_method(c, m, &b)
  eigenclass = class << c; self; end 
  eigenclass.class_eval {
    define_method(m, &b)
  }
end

add_class_method(String, :greet) {|name| "Hello, " +  name }

String.greet("world")   # => "Hello, world"
# 或者
String.define_singleton_method(:greet) {|name| "Hello, " + name }
#
# 通过alias_method动态创建别名
# Create an alias for the method m in the class (or module) c
def backup(c, m, prefix="original")
  n = :"#{prefix}_#{m}"
  c.class_eval {
    alias_method n, m
  }
end 

backup(String, :reverse)
"test".original_reverse   # => "tset"
#
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# 
# method_missing
# ~~~~~~~~~~~~~~
class Hash
  # Allow hash values to be queried and set as if they were attributes.
  # We simulate attribute getters and setters for any key. 
  def method_missing(key, *args)
    text = key.to_s
    if text[-1,1] == "="                  # If key ends with = set a value 
      self[text.chop.to_sym] = args[0]    # Strip = from key 
    else 
      self[key]                           # ...just return the key value 
    end 
  end 
end 

h = {}      # Create an empty hash object 
h.one = 1   # Same as h[:one] = 1
puts h.one  # Same as h[:one]
#
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# 动态设置方法可见性
# ~~~~~~~~~~~~~~~~~~
String.class_eval { private :reverse }
"hello".reverse   # NoMethodError: private method 'reverse'

# Make all Math methods private 
# Now we have to include Math in order to invoke its methods 
Math.private_class_method *Math.singleton_methods 
# 
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# Hooks 钩子方法
# ~~~~~~~~~~~~~~
#
# inherited
# 当子类集成超类时，超类调用inherited方法
def Object.inherited(c)
  puts "class #{c} < #{self}"
end 

class A < Object    # => class A < Object 
#
# included 
# 当模块被包含时，模块调用included方法
module Final                  # A class that includes Final can't be subclassed 
    def self.included(c)      # When included in c
      c.instance_eval do      # Define a class method of c 
        def inherited(sub)    # To detect subclass
          raise Exception, 
            "Attempt to create subclass #{sub} of Final class #{self}"
        end 
      end 
    end 
end 
#
# method_added
# 当类或模块增加一个实例方法时调用
def String.method_added(name)
  puts "New instance method #{name} added to String"
end 
# 
# singleton_method_added
# 当对象增加单键方法时调用
def String.singleton_method_added(name)
  puts "New class method #{name} added to String"
end 
# 作为模块的实例方法，当向包含模块类添加单键方法时调用
module Strict 
  def singleton_method_added(name)
    STDERR.puts "Warning: singleton #{name} added to a Strict object"
    eigenclass = class << self; self; end 
    eigenclass.class_eval { remove_method name }
  end 
end 
# 
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# Tracing 跟踪
# ~~~~~~~~~~~~
# 两个重要的关键字 __FILE__  __LINE__
# 
# 异常信息是基于__FILE__和__LINE__得到的 
# 每一个Exception对象关联一个追踪信息，Exception.backtrace方法返回包含这些信息的字符串数组
# 数组的第一个元素是异常发生的位置，后面每个元素是更高一级的调用栈
#
# Kernel.caller返回当前调用堆栈的状态
# caller第一个元素是调用caller的方法
# 默认caller第二个参数为1，即忽略调用的方法
# 所以caller[0]等价于caller(0)[1],caller[1..-1]等价于caller(2)
#
# 可以使用Kernel.__method__来获取调用方法名
# 与__FILE__和__LINE__配合使用时很有用
raise "Assertion failed in #{__method__} at #{__FILE__}:#{__LINE__}"
# 
# Kernel.trace_var 和 Kernel.untrace_var 
# 跟踪全局变量
# Print a message every time $SAFE changes
trace_var(:$SAFE, Proc.new {|v| puts "$SAFE set to #{v} at #{caller[1]}" })
#
# ---------------------------------------------------------------------------------------------------------------------------------------------------
