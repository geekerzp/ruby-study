# ========================
# |  ObjectSpace and GC  |
# ========================
#
# ObjectSpace模块定义了一组方便的低级方法，它们有时对调试和元编程有用
#
# ObjectSpace.each_object
# 迭代出解释器知道的每个对象
# Print out a list of all known classes 
ObjectSpace.each_object {|c| puts c }
# 
# ObjectSpace._id2ref
# 返回每个id对应的对象
# Object.object_id 的相反过程
#
# ObjectSpace.define_finalizer 
# 注册一个Proc对象或一个代码块，它们在给定对象被垃圾收集时调用
#
# ObjectSpace.undefine_finalizer
# 为一个对象删除所有注册的finalizer块
#
# ObjectSpace.garbage_colect
# 强制让Ruby运行垃圾收集器
# GC.start 是 ObjectSpace.garbage_colect的同义词，可通过GC.disable方法临时关闭垃圾收集，GC.enable使之再次生效
#
# ObjectSpace._id2ref 和 define_finalizer配合可实现"弱引用"
# "弱引用": 对象保有值的引用，然而，在它们不可用时并不阻止对它们进行垃圾回收
# 标准库的WeakRef类有实例
# ---------------------------------------------------------------------------------------------------------------------------------------------------
