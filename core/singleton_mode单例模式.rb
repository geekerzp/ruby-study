# 用单例模式统计点的状态信息
# 使用类方法instance获取单例
#
require 'singleton'

class PointStats
  include Singleton

  def initialize
    @n, @totalX, @totalY = 0, 0.0, 0.0
  end

  def record(point)   # 记录点的状态
    @n += 1
    @totalX += point.x
    @totalY += point.y
  end
  
  def report          # 输出点的状态
    puts "Number of points created: #{@n}"
    puts "Average X coordinate: #{@totalX/@n}"
    puts "Average Y coordinate: #{@totalY/@n}"
  end
end

