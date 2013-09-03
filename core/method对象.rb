Method对象
Object类定义了一个名为method的方法，它接受一个用字符串或符号表示的方法名
返回的Method对象表示在接受者对象中相应的方法，如果没有这个方法，则抛出一个NameError异常
m = 0.method(:succ)         # A method representing the succ method of Fixnum 0
puts m.call                 # Same as puts 0.succ Or use puts m[]

还可以通过public_method方法获得一个Method对象，它与method方法类似，但是忽略protected方法和private方法
-----------------------------------------------------------------------------------------------------------------------------------------------------
Method对象和Proc对象的相互转换
Method对象转换为Proc对象
Method.to_proc方法把method对象转换为Proc对象，这就是为什么Method对象可以用一个&做前缀
然后使用这个对象取代代码块作为参数传递的原因
def square(x); x*x; end
puts (1..10).map(&method(:square))

Proc对象转换为Method对象
Module的define_method方法要求一个Symbol对象作为参数，它把这个符号作为方法名
以关联的代码块为方法的主体来创建一个方法，如果不用一个方法，也可以用一个Proc对象或Method对象为方法的第二个参数
define_method(:square) { x*x }
-----------------------------------------------------------------------------------------------------------------------------------------------------
Method对象的绑定值是self，该方法的宿主对象

Method类的常用方法
name: 返回方法的名字
owner: 返回这个方法定义的类
receiver：返回该方法绑定的对象
-----------------------------------------------------------------------------------------------------------------------------------------------------
UnboundMethod无绑定类
创建一个UnboundMethod对象
unbound_plus = Fixnum.instance_method("+")

绑定到一个对象，返回一个Method对象
plus_2 = unbound_plus.bind(2)     # Bind the method to the object 2

调用Method对象的call方法
sum = plus_2.call(2)

重新绑定一个Method对象
plus_3 = plus_2.unbind.bind(3)
-----------------------------------------------------------------------------------------------------------------------------------------------------


