# 
# 当方法参数的最后一个值为哈希时，哈希括号可以省略。
#-------------------------------------------------------------------------------
# 如果方法的最后一个参数前有&符号，Ruby将认为它是一个Proc对象。
# 它会将其从参数列表中删除，并将Proc对象转换为一个block，然后关联到该方法。
