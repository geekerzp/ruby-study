组合模式(Composite Pattern [Gang of Four])
==========================================
在构建一个基于树形复杂结构的对象群的时候，通常我们可以采用组合模式来构建系统，
通过继承和聚合使得对象与对象之间产生层级性质的关联，并又尽可能的降低他们之间的耦合度。

现在来用组合模式来构造一个DOM结构的系统,首先定义一个root类

      class Div 
        
        def initialize(name)
          @name = name 
        end 

        def get_dom_identified
          "div"
        end 

      end 

定义两个root类的子类

    class Input < Div 

      def initialize(name)
        super(name)
      end 

      def get_dom_identified
        "input"
      end 

    end 

    class Textarea < Div
      
      def initialize(name)
        super(name)
      end 

      def get_dom_identified
        "textarea"
      end 

    end 

两个子类当中分别重写了get_dom_identified方法，用于自己类特定的实现。
现在把root类和两个子类产生双向关联，形成树形结构。

    class Div 
      
      attr_accessor :name, :parent 

      def initialize(name)
        @name = name 
        @parent = nil 
        @sub = []
      end 

      def get_dom_identified
        "div"
      end 

      def add_sub(sub)
        @sub << sub
        sub.parent = self 
      end 

      def del_sub(sub)
        @sub.delete(sub)
      end 

    end 

    class Input < Div
      
      def initialize(name, parent)
        super(name)
        @parent = parent 
      end 

      def get_dom_identified
        "input"
      end 

    end 

    class Textarea < Div 
      
      def initialize(name, parent)
        super(name)
        @parent = parent
      end 

      def get_dom_identified
        "textarea"
      end 

    end 

    root = Div.new("div")
    input = Textarea.new("textarea", root)
    root.add_sub input 
    p input.parent.name

通过上述代码，明确了三个类的层级关系，并且用聚合的方式来产生关联，
root类负责管理所有的子类，而子类保存了root类的引用，当root类增加子类的同时改变子类的对父类的引用，
从而形成了树形结构。这里只有三个类，可以N个类，一层一层的建立这些层级关系，比如再定义一个table类继承与Div类，
又定义Tr类继承于table类，一层接着一层，同时通过组合模式建立对象与对象之间的关联。

在组合模式中，本类负责管理所有属于他自己的子类集合，而子类有父类的引用，
负责管理子类的类叫做Composite，而处于被管理且叶子节点的类成为leaf。

在composite类中递归获取到所有的子类的个数(包含composite和leaf)

通过递归来获得一个类下的所有的子类

    def get_sub_count  
        count = @sub.length  
        @sub.each do |single_sub|  
          count += single_sub.get_sub_count  
        end  
        count  
    end  
