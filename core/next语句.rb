# next语句作用
# ~~~~~~~~~~~~
# 使控制流程从外围方法或代码块返回
# 使控制流程从外围方法返回
#
# Return the index of the first occurrence of target within array or nil
# Note that this code just duplicates the Array.index method
def find(array, target)
	array.each_with_index do |element,index|
		return index if (element == target)				# return from find
	end
	nil																					# If we didn't find the element, return nil
end

# 使控制流程从代码块返回
f.each do |line|
  next if line[0,1] == "#"										# Iterator over the lines in file f
	puts eval(line)															# If this line is a comment, go to the next
end
# ------------------------------------------------------------------------------------------------------------------------------------------------------
# next返回值
# ~~~~~~~~~~
# 如果没有返回值则返回nil
# 如果有一个返回值直接返回
# 如果有多个返回值返回数组
squareroots = data.collect do |x|
  next 0 if x < 0 									# Return 0 for negative values
	Math.sqrt(x)
end
# 等价于
squareroots = data.collect do |x|
  if (x < 0) then 0 else Math.sqrt(X) end
end
