# ====================
# |  延迟和重复执行  |
# ====================
#
require '../../../program/afterevery.rb'

1.upto(5) {|i| after(i) { puts "after:", i } }     # Slowly print the numbers 1 to 5
sleep(5)                                          # Wait five seconds 
every 1, 6 do |count|                             # Now slowly print 6 to 10 
  puts "every:", count 
  break if count == 10 
  count + 1                                       # Tne next value of count 
end         
sleep(6)                                          # Give the above time to run 
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# ============================
# |  用同步代码实现线程安全  |
# ============================
#
require 'thread'

# Obtain the Mutex associated with the object o, and then evaluate 
# the block under the protection of that Mutex.
# This works like the synchronized keyword of Java.
# This global synchronized method can now be used in three different ways.
def synchronized(*args)
  # Case 1: with one argument and a block, synchronize on the block
  # and execute the block.
  if args.size == 1 && block_given?
    args[0].mutex.synchronize { yield }

  # Case 2: with one agrument that is not a symbol and no block
  # return a SynchronizedObject wrapper.
  elsif args.size == 1 and not args[0].is_a? Symbol and not block_given?
    SynchronizedObject(args[0])

  # Case 3: when invoked on a module with no block, alias chain the 
  # named method to add synchronization. Or, if there are no arguments,
  # then alias chain the next method defined.
  elsif self.is_a? Module and not block_given?
    if (args.size > 0)    # Synchronized the named methods 
      args.each {|m| self.synchronize_method(m) }
    else 
      # If no methods are specified synchronize the next method defined
      eigenclass = class << self; self; end 
      eigenclass.class_eval do  # Use eigenclass to define class methods 
        # Define method_add for notification when next class method is defined 
        define_method :method_add do |name|
          # First remove this hook method 
          eigenclass.class_eval { remove_method :method_add }
          # Next, synchronize the method that was just added 
          self.synchronize_method name 
        end 
      end 
    end 

  # Case 4: any other invocation is an error 
  else 
    raise ArgumentError, "Invalid arguments to synchronized()"
  end 
end 

# Object.mutex does not actually exist. We've got to define it.
# This method returns a unique Mutex for every object, and 
# always returns the same Mutex for any particular object.
# It creates Mutexs lazily, which requires synchronization for 
# thread safety.
class Object 
  # Return the Mutex for this object, creating it if necessary.
  # The tricky part is making sure that two threads don't call 
  # this at same time and end up with creating two different mutexes.
  def mutex 
    # If this object already has a mutex, just return it 
    return @__mutex if @__mutex
    # Otherwise, we've got to create a mutex for the object.
    # To do this safety we've got to synchronize on our class object.
    synchronized(self.class) {
      # Check again: by the time we enter this synchronized block,
      # some other thread might have already created the mutex.
      @__mutex ||= Mutex.new
    }
    # The return value is @__mutex
  end 
end 

# The Object.mutex method defined above needs to lock the class 
# if the object doesn't have a Mutex yet. If the class doesn't have 
# its own Mutex yet, then the class of the class (the Class object)
# will be locked. In order to prevent infinite recursion, we must 
# ensure that the Class objetct has a mutex.
Class.instance_eval { @__mutex = Mutex.new }

# A delegating wrapper class using method_missing for thread safety.
# Instead of extending Object and deleting our methods we just extend.
# BasicObject, which is defined in Ruby 1.9.  
# BasicObject does not inherit from Object or Kernel, so the methods of a BasicObject cannot
# invoke any top-level methods: they are just not there.
class SynchronizedObject < BasicObject
  def initialize(o); @delegate = o; end 
  def __delegate; @delegate; end 

  def method_missing(*args, &block)
    @delegate.mutex.synchronize {
      @delegate.send *args, &block
    }
  end 
end 

# Define a Module.synchronize_method that alias chains instance methods 
# so they synchronize on the instance before running.
class Module
  # This is a helper function for alias chaining.
  # Given a method name (as a string or symbol) and a prefix, create 
  # a unique alias for the method, and return the name of the alias 
  # as a symbol. Any punctuation characters in the operators can be aliased.
  def create_alias(original, prefix="alias")
    # Stick the prefix on the original name and Convert punctuation
    aka = "#{prefix}_#{original}"
    aka.gsub!(/([\=\|\&\+\-\*\/\^\!\?\~\%\<\>\[\]])/) {
      num = $1[0]                         # 1.8
      num = num.ord if num.is_a? String   # 1.9
      '_' + num.to_s
    }

    # Keep appending underscores until we get a name that is not in use 
    aka += "_" while method_defined? aka or private_method_defined? aka 

    aka = aka.to_sym            # Convert the alias name to a symbol
    alias_method aka, original  # Actually create the alias
    aka                         # Return the alias name
  end 

  # Alias chain the named method to add synchronization
  def synchronize_method(m)
    # First, make an alias for the unsynchronized version of the method.
    aka = create_alias(m, "unsync")
    # Now redefine the original to invoke the alias in a synchronized block.
    # We want the defined method to be able to accept blocks, so we 
    # can't use define_method, and must instead evaluate a string with 
    # class_eval. Note that everything between %Q{ and the matching }
    # is a double-quoted string, not a block.
    class_eval %Q {
      def #{m}(*args, &block)
        synchronized(self) { #{aka}(*args, &block) }
      end 
    }
  end 
end 
    
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# ================================================
# |  用const_missing实现Unicode方式的代码点常量  |
# ================================================
#
# This module provides constants that define the UTF-8 strings for 
# all Unicode codepoints. It uses const_missing to define then lazily.
# Examples:
#   copyright = Unicode::U00A9
#   euro = Unicode::U20AC
#   infinity = Unicode::U221E
module Unicode
  # This method allows us to define Unicode codepoints constants lazily.
  def self.const_missing(name)    # Undefined constant passed as a symbol
    # Check that the constant name is of the right form.
    # Capital U followed by a hex number between 0000 and 10FFFF.
    if name.to_s =~ /^U([0-9a-fA-F]{4,5}|10[0-9a-zA-F]{4})$/
      # $1 is the matched hexadecimal number. Convert to an integer.
      codepoint = $1.to_i(16)
      # Convert the number to a UTF-8 string with the magic of Array.pack.
      utf8 = [codepoint].pack("U")
      # Make the UTF-8 string immutable.
      utf8.freeze
      # Define a real constant for faster lookup next time, and return 
      # the UTF-8 text for the time.
      const_set(name, utf8)
    else 
      # Raise an error for constants of the wrong form.
      raise NameError, "Uninitialized constant: Unicode::#{name}"
    end 
  end 
end 
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# ==================================
# |  用method_missing跟踪方法调用  |
# ==================================
#
# Call the trace method of any object to obtain a new object that 
# behaves just like the original, but which traces all method calls 
# on that Object. By default, message will be sent to STDERR,
# but you can specify any stream (or any object that accepts Strings 
# as arguments to <<).
class Object 
  def trace(name="", stream=STDERR)
    # Return a TracedObject that traces and delegates everything to us.
    TracedObject.new(self, name, stream)
  end 
end 

# This class uses method_missing to trace method invocations and 
# then delegate them to some other object. It deletes most of its own 
# instance methods so that they don't get int the way of method_missing.
# Note that only methods invoked through the TracedObject will be traced.
# If the delegate object calls methods on itself, those invocations
# will not be traced.
class TracedObject
  # Undefined all of our noncritical public instance methods.
  # Note the use of Module.instance_mehods and Module.undef_method.
  instance_methods.each do |m|
    m = m.to_sym
    next if m == :object_id || m == :__id__ || m == :__send__
    undef_method m
  end 
  
  # Initialize this TracedObject instance.
  def initialize(o, name, stream)
    @o = o            # The object we delegate to 
    @n = name         # The objetct name to appear in tracing messages 
    @trace = stream   # Where those tracing messages are sent 
  end 
  
  # This is the key method of TracedObject. It is invoked for just 
  # about any method invocation on a TracedObject.
  def method_missing(*args, &block)
    m = args.shift    # Firt arg is the name of the method 
    begin 
      # Trace the invocation of the method.
      arglist = args.map {|a| a.inspect }.join(', ')
      @trace << "Invoking: #{@n}.#{m}(#{arglist}) at #{caller[0]}\n"
      # Invoke the method on our delegate object and get the return value. 
      r = @o.send m, *args, &block
      # Trace a normal return of the method. 
      @trace << "Returning: #{r.inspect} from #{@n}.#{m} to #{caller[0]}\n"
      # Return whaterver value the delegate object returned.
      r
    rescue Exception => e
      # Trace an abnormal return from the method.
      @trace << "Rasing: #{e.class}:#{e} from #{@n}.#{m}\n"
      # And re-raise whaterver exception the delegate object raised.
      raise 
    end 
  end 

  # Return the object we delegate to. 
  def __delegate
    @o
  end 
end 

# Useage:
#   a = [1,2,3].trace("a")
#   a.reverse
#   puts a[2]
#   puts a.fetch[3]
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# ==============================
# |  用class_eval实现属性控制  |
# ==============================
#
# 用Module.readonly，Module.readwrite模拟attr_reader，attr_accessor
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
class Module 
  private     # The methods that follow are both private 

  # This method works like attr_reader, but a shorter name 
  def readonly(*syms)
    return if syms.size == 0    # If no arguments, do nothing 
    code = ""                   # Start with an empty string of code 
    # Generate a string of Ruby code to define attribute reader methods.
    # Notice how the symbol is interpolated into the string of code.
    syms.each do |s|
      code << "def #{s}; #{s}; end\n"
    end 
    # Finally, class_eval the generated code to create instance methods.
    class_eval code 
  end 

  # This method works like attr_accessor, but has a shorter name. 
  def readwrite(*syms)
    return if syms.size == 0
    code = ""
    syms.each do |s|
      code << "def #{s}; #{S}; end\n"
      code << "def #{s}=(value); #{s}=value; end\n"
    end 
    class_eval code 
  end 
end 
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# =================================
# |  用define_method实现属性控制  |
# =================================
#
class Module
  # This method defines attribute reader and writer methods for named 
  # attributes, but expects a hash argument mapping attribute names to 
  # default values. The generated attribute reader methods return the 
  # default value if the instance variable has not yet been defined.
  def attributes(hash)
    hash.each_pair do |symbol, default|   # For each attribute/default pair
      getter = symbol                     # Name of the getter method 
      setter = :"#{symbol}="              # Name of the setter method 
      variable = :"@#{symbol}"            # Name of the instance variable
      define_method getter do             # Define the getter method 
        if instance_variable_defined? variable 
          instance_variable_get variable  # Return variable, if defined 
        else 
          default                 # Otherwise return default
        end 
      end 

      define_method setter do |value|           # Define the setter method 
        instance_variable_set variable, value   # Set the instance variable to the argument value 
      end 
    end 
  end 

  # This method works like attributes, but defines class methods Instead 
  # by invoking attributes on the eigenclass instead of on self.
  # Note that the defined methods use class instance variables 
  # Instead of regular class variables.
  def class_attrs(hash)
    eigenclass = class << self; self; end 
    eigenclass.class_eval { attributes(hash) }
  end 

  # Both methods are private 
  private :attributes, :class_attrs
end 
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# =====================================
# |         别名链(猴子补丁)          |
# |  alias chaining(monkey patching)  |
# =====================================
#
# 实现原理
# ~~~~~~~~
# 1.首先，创建一个要修改方法的别名。这个别名用作该方法未修改版本的名称。
# 2.接着，定义该方法的新版本。这个新方法应该通过别名调用该方法的未修改版本，
#   不过在调用它之前或之后可以加入新功能。
# 3.这些步骤重复使用，就创建了一个别名链。
#
# 跟踪文件加载和类定义
# ~~~~~~~~~~~~~~~~~~~~
# We define this module to hold the global state we require, so that 
# we don't alter the global namespace any more than necessary. 
module ClassTrace
  # This array holds our list of files loaded and classes defined.
  # Each element is a subarray holding the class defined or the 
  # file loaded and the stack frame where it was defined or loaded.
  T = []    # Array to hold the files loaded

  # Now define the constant OUT to specify where tracing output goes.
  # This defaults to STDERR, but can also come from command-line arguments.
  if x = ARGV.index("--traceout")     # If argument exists 
    OUT = File.open(ARGV[x+1], "w")   # Open the specified file 
    ARGV[x,2] = nil                   # And remove the arguments
  else 
    OUT = STDERR                      # Otherwise default to STDERR
  end 
end 

# Alias chaining step 1: define alias for the original methods 
alias original_require require
alias original_load load 

# Alias chaining step 2: define new version ot the methods   
def require(file)
  ClassTrace::T << [file,caller[0]]   # Remember what was loaded where 
  original_require(file)              # Invoke the original method 
end 

def load(*args)
  ClassTrace::T << [args[0],caller[0]]    # Remember what was loaded where 
  original_load(*args)                    # Invoke the original method 
end 

# This hook method is invoked each time a new class is defined 
def Object.inherited(c)
  ClassTrace::T << [c,caller[0]]    # Remember what was defined where 
end  

# Kernel.at_exit registers a block to be run when the program exists. 
# We use it to report the file and class data we collected.
at_exit do 
  o = ClassTrace::OUT
  o.puts "="*60
  o.puts "Files Loaded and Classes Defined:"
  o.puts "="*60
  ClassTrace::T.each do |what,where|
    if what.is_a? Class   # Report class (with hierarchy) defined 
      o.puts "Defined:  #{what.ancestors.join('<-')} at #{where}"
    else                  # Report file loaded 
      o.puts "Loaded:   #{what} at #{where}"
    end 
  end 
end 
#
# Useage:
#  ruby -rclasstrace my_program.rb --traceout /tmp/trace
#
#
# 用方法链实现跟踪
# ~~~~~~~~~~~~~~~~
# Define trace! and untrace! instance methods for all objects.
# trace! "chains" the named methods by defining singleton methods 
# that add tracing functionality and then use super to call the original.
# untrace! deletes the singleton methods to remove tracing.
class Object 
  # Trace the specified methods, sending output to STDERR.
  def trace!(*methods)
    @_traced ||= []   # Remember the set of traced methods
      
    # If no methods were specified, use all public methods defined
    # directly (not inherited) by the class of this object 
    methods = public_methods(false) if methods.size == 0
    methods.map! {|m| m.to_sym }    # Convert any strings to symbols
    methods -= @_traced             # Remove methods that are already traced 
    return if methods.empty?        # Return early if there is noting to do 
    @_traced |= methods             # Add methods to set of traced methods 

    # Trace the fact that we're starting to trace these methods
    STDERR << "Tracing #{methods.join(', ')} on #{object_id}\n"

    # Singleton methods are defined in the eigenclass 
    eigenclass = class << self; self; end 

    methods.each do |m|   # For each method m 
      # Define a traced singleton version of the method m.
      # Output tracing information and use super to invoke the 
      # instance method that it is tracing.
      # We want the defined methods to be able to accept blocks, so we 
      # can't use define_method, and must instead evaluate a string.
      # Note that everything between %Q{ and the matching } is a 
      # double-quoted string, not a block. Also note that there are 
      # two levels of string interpolations here. #{} is interpolated 
      # when the singleton method is defined. And \#{} is interpolated 
      # when the singleton method is invoked.
      eigenclass.class_eval %Q{
        def #{m}(*args, &block)
          begin 
            STDERR << "Entering: #{m} (\#{args.join(', ')})\n"
            result = super 
            STDERR << "Exiting: #{m} with \#{result}\n"
            result 
          rescue
            STDERR << "Aborting: #{m}: \#{$!.class}: \#{$!.message}"
            raise 
          end 
        end 
      }
    end
  end 

  # Untraced the specified methods or all traced methods
  def untrace!(*methods)
    if methods.size == 0    # If no methods specified untrace
      methods = @_traced    # all currently traced methods 
      STDERR << "Untracing all methods on #{object_id}\n"
    else                    # Otherwise, untrace
      methods.map! {|m| m.to_sym }
      methods &= @_traced   # picked out all traced methods 
      STDERR << "Untracing #{methods.join(', ')} on #{object_id}\n"
    end 

    @_traced -= methods     # Remove them from our set of traced methods 

    # Remove the traced singleton methods from the eigenclass
    # Note that we class_eval a block here, not a string 
    (class << self; self; end).class_eval do 
      methods.each do |m|
        remove_method m     # undef_method would not work correctly
      end 
    end 

    # If no methods are traced anymore, remove out instance var 
    if @_traced.empty?
      remove_instance_variable :@_traced
    end 
  end
end 
#
# ---------------------------------------------------------------------------------------------------------------------------------------------------



