属于某个对象的方法称为单键方法
o = "message"           # A string is an object
def o.printme           # Define a singletion method for this object
  puts self
end
o.printme               # Invoke the singletion
Fixnum和Symbol的值看作立即值(immediate value)，而非真正的对象引用，因此，Fixnum和Symbol对象无法定义singletion method
为保持一致性，其他Numeric对象也无法定义单键方法


