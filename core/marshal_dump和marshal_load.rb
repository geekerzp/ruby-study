# Marshal.load方法来重新生成早先用Marshal.dump序列化的对象
# Marshal.dump方法保存一个对象，并递归序列化其中每个实例变量的值
#
class Point                 # A point in n-space
  def initialize(*coords)   # Accept an arbitrary # of coordinates
    @coords = coords        # Store the coordinates in an array
  end

  def marshal_dump          # Pack coords into a atring and marshal that 
    @coords.pack("w*")
  end

  def marshal_load(s)         # Unpack coords from unmarshaled string 
    @coords = s.unpack("w*")  # and use them to initialize the object 
  end
end
