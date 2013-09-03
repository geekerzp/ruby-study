class Point
  # Define an initialize method as usual...
  def initialize(x,y)       # Expects Cartesian coordinates
    @x,@y = x,y
  end

  # But make factory method new private
  private_class_method :new 

  def Point.cartesian(x,y)  # Factory method for Cartesian coordinates
    new(x,y)                # We can still new from other class methods
  end

  def Point.polar(r,theta)  # Factory method for polar coordinates
    new(r*Math.cos(theta), r*Math.sin(theta))
  end
end
