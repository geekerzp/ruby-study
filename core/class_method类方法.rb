==========================
|  定义类方法的三种方式  |
==========================

### 1. ###

    class Point
      attr_reader :x, :y
      def Point.sum(*points)
        x = y = 0
        points.each {|p| x += p.x; y += p.y }
        Point.new(x,y)
      end
    end 


### 2. ###

  class Point
    attr_reader :x, :y
    def self.sum(*points)
      x = y = 0
      points.each {|p| x += p.x; y += p.y }
      Point.new(x,y)
    end
  end

### 3. ###

    class << Point
      def sum(*points)
        x = y = 0
        points.each {|p| x += p.x; y += p.y }
        Point.new(x,y)
      end
    end
# 或
class Point
  # Instance methods go here
  
  class << self
    # Class methods go here
  end
end
# ------------------------------------------------------------------------------
#
# ==================
# |  类方法的权限  |
# ==================
#
# 类方法具有private,public,protected三种访问权限
# public类方法可以由类显式调用，或在类中self显式调用，或隐式调用
# private类方法只能在类中隐式调用
# 







