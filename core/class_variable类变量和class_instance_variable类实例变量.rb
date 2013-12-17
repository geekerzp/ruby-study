# ============
# |  类变量  |
# ============
# 实例方法和类方法都可以操作类变量。
class Point
  # Initialize our class variables in the class definition itself
  @@n = 0                     # How many points have been created
  @@totalX = 0                # The sum of all X coordinates 
  @@totalY = 0                # The sum of all Y coordinates 

  def initialize(x,y)         # Initialize method
    @x,@y = x,y               # Sets initial values for instance variables
    
    # Use the class variables in this instance method to collect data
    @@n += 1                  # Keep track of how many Points have been created
    @@totalX += @x            # Add these coordinates to the totals 
  end

  # A class method to report the data we collected
  def self.report
    # Here we use the class variables in a method
    puts "Number of points created: #@@n"
    puts "Average X coordinate: #{@@totalX.to_f/@@n}"
    puts "Average Y coordinate: #{@@totalY.to_f/@@n}"
  end
end

# ------------------------------------------------------------------------------
# ================
# |  类实例变量  |
# ================
# 在类定义体内而在实例方法定义体外使用的实例变量被称为类实例变量
# 类变量可以被子类继承和修改，类实例变量不可以被子类继承和修改
# 类是Class类的实例，类实例变量为类的meta-class的实例变量，类方法为类的meta-class的实例方法

class Point
  # Initialize our class instance variables in the class definition itself
  @n = 0                        # How many points have been created
  @totalX = 0                   # The sum of all X coordinates
  @totalY = 0                   # The sum of all Y coordinates

  def initialize(x,y)           # Initialize method
    @x,@y = x,y                 # Sets initial values for instance variables
  end

  def self.new(x,y)             # Class method to create new Point objects
    # Use the class instance variables in this class method to collect data
    @n += 1                     # Keep track of how many Points have been created
    @totalX += 1                # Add these coordinates to the totals 
    @totalY += 1

    super                       # Invoke the real definition of new to create a Point
                                # More about super later in the chapter
  end

  def self.report
    # Here we use the class instance variables in a class method 
    puts "Number of points created: #@n"
    puts "Average of X coordinate: #{@totalX.to_f/@n}"
    puts "Average of Y coordinate: #{@totalY.to_f/@n}"
  end

  class << self
    # Define the class method to access class instance variables
    attr_accessor :n, :totalX, :totalY 
  end
end

# ------------------------------------------------------------------------------
# ==============================
# |  类变量和类实例变量的区别  |
# ==============================
# 类实例变量是类的单例变量，只能被当前类使用，不能被其子类使用。同时，
# 只能在类上下文中使用。
# 类变量可以被当前类和其子类使用，可以在类的上下文或对象的上下文中使用。
