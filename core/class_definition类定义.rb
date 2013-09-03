# Define a Point class 
class Point
  attr_accessor :x, :y

  def initialize(x,y)
    @x,@y = x,y
    PointStats.instance.record(self)    # 用单例模式统计点的状态
  end

  def to_s
    puts "(#{@x},#{@y})"
  end
end


