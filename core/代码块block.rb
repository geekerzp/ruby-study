如果代码块中操作一个不同外围变量时，将会对外围变量赋值
total = 0
data.each {|x| total += x}										# Sum the elements of the data array
puts total 																		# => sum
------------------------------------------------------------------------------------------------------------------------------------------------------
如果代码块中操作一个相同的外围变量时，将会隐藏外围变量
1.upto(10) do |i|
	1.upto(10) do |i|
		print "#{i}"
	end
	print " ==> Row #{i}\n"
end
OUTPUT:
12345678910==>Row1
12345678910==>Row2
12345678910==>Row3
12345678910==>Row4
12345678910==>Row5
12345678910==>Row6
12345678910==>Row7
12345678910==>Row8
12345678910==>Row9
12345678910==>Row10
------------------------------------------------------------------------------------------------------------------------------------------------------
声明块级局部变量
x = y = 0																			# local variables
1.upto(4) do |x;y|														# x and y are local to block
	y = x + 1																		# x and y "shadow" the outer variables
	puts y*y																		# Use y as a scratch variable, prints 4, 9, 16, 25
end
[x, y]																				# => [0, 0]: block does not alter these
块级x形参将局部变量x隐藏，块级y变量将局部变量y隐藏

代码块可以具有多个参数以及多个块级局部变量
hash.each {|key,value; i,j,k|}
------------------------------------------------------------------------------------------------------------------------------------------------------
参数赋值时使用*可以接受多个参数
def five; yield 1,2,3,4,5; end 								# Yield 5 values
five do |head, *body, tail|										# Extra values go into body array
	print head, body, tail 											# Prints "1[2,3,4]5"
end
------------------------------------------------------------------------------------------------------------------------------------------------------
参数复制时使用&可以接受块闭包参数
# This Proc expects a block
printer = lambda {|&b| puts b.call }
printer.call { "hi" }
------------------------------------------------------------------------------------------------------------------------------------------------------
1.8
代码块形参和方法形参之间的一个重要差别是：
代码块形参不允许有默认值，方法形参允许有默认值
[1,2,3].each {|x,y=10| print x*y}							# SyntaxError!

1.9
代码块形参可以具有默认值
[1,2,3].each {|x,y=10| print x*y}							# Ok!
------------------------------------------------------------------------------------------------------------------------------------------------------

