方法名解析
==========

    o.m
     1.首先，检查o的eigenclass是否有名为m的单键方法
     2.如果在eigenclass中没有方法m，在o的类中寻找名为m的单键方法
     3.如果在类中没有找到m方法，Ruby在所包含的模块中寻找名为m的实例方法
       如果包含的模块不止一个，它们以包含顺序的逆序被查找
     4.如果在类中和包含的模块中都找不到实例方法m，Ruby会向上到超类中去查找，
       重复2,3步
     5.如果进行了这样的查找还是没有找到一个名为m的方法，就会调用一个名为method_missing的方法，
       为了找到该方法的定义，Ruby将从第一步开始执行这个名字解析算法，
       Kernel模块为method_missing方法提供了一个默认实现，所以这个名字解析算法一定会被解析成功
