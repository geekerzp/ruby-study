# ===========
# |  undef  |
# ===========
# 用undef取消方法定义
# 在一个方法或模块中，还可以使用undef_method方法来取消方法定义
#--------------------------------------------------------------------------------
alias可以为方法声明别名
一般用于为一个方法增加新的功能
def hello                                 # A nice simple method
  puts "Hello World"                      # Suppose we want to augment it...
end

alias original_hello hello                # Give the method a backup name

def hello                                 # Now we define a new method with the old name
  puts "Your attention please"            # That does some stuff
  original_hello                          # Then calls the original method
  puts "This has been a test"             # Then does some more stuff 
end 
#-------------------------------------------------------------------------------
# ==================
# |  变长参数列表  |
# ==================
# Return the largest of the one or more arguments passed
def max(first, *rest)
  # Assume that the required first argument is the largest
  max = first
  # Now loop through each of the optional arguments looking for bigger ones
  rest.each {|x| max = x if x > max }
  # Return the largest one we found
  max
end
#"*"为splat数组分解操作符，代表所要操作的对象是一个数组
#-------------------------------------------------------------------------------
# ====================
# |  哈希表作为参数  |
# ====================
# This method returns an array a of n numbers. For any index i, 0 <= i < n,
# the value of element a[i] is m*i+c. Arguments n, m, and c are passed
# as keys in path, so that it is not necessary to remember their order.
def sequence(args)
  # Extract the arguments from the hash.
  # Note the use of the || operator to specify defaults used.
  # if the hash does not define a key that we are interested in.
  n = args[:n] || 0
  m = args[:m] || 1
  c = args[:c] || 0
  a = []                                # Start with an empty array
  n.times {|i| a << m*i+c }             # Calculate the value of each array element
  a                                     # Return the array
end

# Usage:
  sequence({:n=>3, :m=>5})              # 传递哈希表
  sequence(:n=>3, :m=>5)                # 省略哈希大括号
  sequence c:1, m:3, n:5                # 参数小括号
#-------------------------------------------------------------------------------
# =========================
# |  代码块block作为参数  |
# =========================
# ### *隐式传递*
def sequence2(n, m, c)
  i = 0
  while (i < n)
    yield i*m + c
    i += 1
  end 
end 
# Usage:
  sequence2(3, 5, 1) {|x| puts x }

# ### *显式传递*
def sequence3(n, m, c, &block)          # Explicit argument to get block as a Proc
  i = 0
  while (i < 0)
    block.call(i*m + c)                     # Invoke the Proc with its call method
    i += 1
  end 
end 
# Usage:
  sequence3(5, 2, 2) {|x| puts x }

# ### *另一种显式传递方法*
def sequence4(n, m, c, b)
  i = 0
  while (i < n)
    b.call(i*m + c)
    i += 1
  end 
end 
# Usage:
  p = Proc.new {|x| puts x }
  sequence4(5, 2, 2, p)

# ### *在哈希表参数后接一个块参数*
def sequence5(args, &b)       # Pass arguments as a hash and follow with a block
  n, m, c = args[:n], args[:m], args[:c]
  i = 0 
  while (i < n)
    b.call(i*m + c)
    i += 1
  end 
end 

# ### *在数组参数列表后接一个块参数*
def max(first, *rest, &block)
  max = first
  reset.each {|x| max = x if x > max }
  block.call(max)
  max 
end

#-------------------------------------------------------------------------------
# =======================
# |  在方法调用时使用&  |
# =======================
# ### *传递实参时，&代表传递一个Proc对象*
a, b = [1,2,3], [4,5]
summation = Proc.new {|total,x| total+x }
sum = a.inject(0, &summation)             # => 6
sum = b.inject(sum, &summation)           # => 15

### *&接一个Symbol对象*
# 把enumerable对象中的第一个对象的相应方法，通过to_proc转换为一个闭包对象，
# 依次执行enumerable其他对象的相应方法。
words = ['and', 'but', 'car']             # An array of words
uppercase = words.map &:upcase            # Convert to uppercase with String.upcase
upper = words.map {|w| w.upcase }         # This is the equivalent code with a block
-----------------------------------------------------------------------------------------------------------------------------------------------------

