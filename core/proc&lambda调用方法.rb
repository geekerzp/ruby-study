f = Proc.new {|x,y| 1.0/(1.0/x + 1.0/y) }

第一种方法:z = f.call(x,y)
第二种方法:z = f.(x,y)
第三种方法:z = f[x,y]
