#
# ====================
# |  执行Ruby解释器  |
# ====================
#
# ruby [options] [--] program [arguments]
#
# 常用选项
# ~~~~~~~~
# -w:         遇到废弃或问题代码时给出警告，同时设置$VERBOSE为true。
# -e script:  运行单行程序。
# -I path:    把path中的目录加到全局$LOAD_PATH数组的起始处，load和require方法会在
#             该数组包含的目录中搜索加载文件。
# -r libaray: 在程序运行前加载给定的libaray。
#-rubygems:   它从标准库中加载名ubygems的模块，而ubygems模块会直接加载真正的
#             rubygems模块。在1.9中，gem无须通过rubygems模块加载，但在1.8中，
#             后者是必须的。
#--disable-gems: 1.9选项，它会阻止把额外的gem安装路径放到默认加载路径中。
#                减少程序启动时间。
#-d, --debug: 把全局变量$DEBUG和$VERBOSE设置为true，它们可以被程序或代码库使用，
#             用来打印调试信息或别的操作。
#-h:          帮助选项。
#
# 警告和信息选项
# ~~~~~~~~~~~~~~
# -W, -W2, --verbose: 打开verbose警告并设置$VERBOSE为true。
# -W0:                禁用所有的警告。
# -v:                 显示ruby版本号。
# --version,
# --copyright,
# --help:             显示ruby的版本号，版权信息，命令行帮助信息。
#
# 编码选项
# ~~~~~~~~
# -K code:            设置ruby的外部编码方式以及设置默认源程序编码方式。
#                     a,A,n,N为ASCII,
#                     u,U为Unicode。
# -E encoding,
# --encoding=encoding:使用全称设定编码方式。
#
# 文本处理选项
# ~~~~~~~~~~~~
# -0 xxx:     xxx为不小于0的3位八进制数，如果指定了这个选项，这个数字代表的ASCII
#             码成为输入数据记录的分隔符，并且相应设置$/变量值。这个分隔符成为
#             gets或类似方法定义“一行”文本。
#             单独使用-0会用编码0设置$/变量。
#             -00使用连续的两个换行符分隔文本行。
# -a:         自动把输入的每行分割成字段，并把这些字段存储在$F变量中。
#             这个选项只在使用-n或-p循环属性时，并且在每次迭代开始处增加$F=$_.split
#             代码时才有效。
# -F fieldsep:用fieldsep的值设定输入字段的分隔符$;。
# -i [ext]:   这个选项编辑命令行指定的文件，并取代原有文件。程序从这些文件中读取
#             文本行，输出的文本直接替换现有文件。如果指定了ext，那么为原始文件
#             生成一个备份，文件名是原有文件加上ext后缀。
# -l:         这个选项使输出记录分隔符$\与输入记录分隔符$/相同。
# -n:         使程序像如下循环一样:
#               while gets             # Read a line of input into $_
#                 $F = split if $-a    # Split $_ into fields if -a was specified
#                 chop! if $-l         # Chop line ending off $_ if -l was specified
#                 # Program text here
#               end
# -p:         使程序像如下循环一样运行:
#               while gets
#                 $F = split if $-a
#                 chop! if $-l
#                 # Program text here
#                 print               # Output $_(adding $/ if -l was specified)
#               end
#
# 杂项选项
# ~~~~~~~
# -c:             解析程序并报告其中的语法错误，但是不运行程序。
# -C dir, -X dir  在运行程序前将当前目录切换到dir下。
# -s              如果指定了这个选项，解释器会把预处理程序名后用连字符开头的参数。对于那些形如-x=y的参数，
#                 解释器把$x设置为y，对于形如-x的参数，解释器设置$x为true。
#                 这些预处理过的参数将从ARGV中被移除。
# -S              如果不能找到程序，解释器将在PATH环境变量的相对路径下寻找。
#                 如果仍然没有找到，再按照普通的方式查找。
# -T n            将$SAFE设置为n，如果n没有被指定，则设置$SAFE为1。
# -x [dir]        这个选项从给定程序中抽取Ruby源程序，抽取的程序不包含首个以#!ruby开头的文本行之前的内容。
#                 因为它兼容大写的-X选项，也可以指定一个目录，切换到目录下抽取源程序。
# -----------------------------------------------------------------------------
#
# ==============
# |  顶层环境  |
# ==============
#
# 预定义的模块和类
# ~~~~~~~~~~~~~~~~
# 解释器启动时定义的module
# Comparable    FileTest      Marshal       Precision
# Enumerable    GC            Math          Process
# Errno         Kernel        ObjectSpace   Signal

# 解释器启动时定义的Class
# Array         File          Method        String
# Bignum        Fixnum        Module        Struct
# Class         Hash          Numeric       Thread
# Continuation  IO            Object        ThreadGroup
# Data          Integer       Proc          Time
# Dir           MatchData     Range         TrueClass
# FalseClass    MatchingData  Regexp        UnboundMethod

# 解释器启动时定义的异常类Exception
# ArgumentError       NameError             SignalException
# EOFError            NoMemoryError         StandardError
# Exception           NoMethodError         SyntaxError
# FloatDomainError    NotImplementedError   SystemCallError
# IOError             RangeError            SystemExit
# IndexError          RegexpError           SystemStackError
# Interrupt           RuntimeError          ThreadError
# LoadError           ScriptError           TypeError
# LocalJumpError      SecurityError         ZeroDivisionError

# 其他
# BasicObject   FiberError    Mutex         VM
# Fiber         KeyError      StopIteration

# 检测环境中的模块，类和异常
# Print all modules(excluding classes)
puts Module.constants.sort.select {|x| eval(x.to_s).instance_of? Module }

# Print all classes(excluding exceptions)
puts Module.constants.sort.select {|x|
  c = eval(x.to_s)
  c.is_a? Class and not c.ancestors.include? Exception
}

# Print all exceptions
puts Module.constants.sort.select {|x|
  c = eval(x.to_s)
  c.instance_of? Class and c.ancestors.include? Exception
}

#------------------------------------------------------------------------------
#
# ==============
# |  顶级常量  |
# ==============
ARGF
#  一个IO对象，它把ARGV中指定的所有文件虚拟连接起来成为一个文件。
#  如果ARGV为空，那么它表示标准输入。它是$<的同义词。
ARGV
#  一个数组，包含所有命令行指定的参数。它是$*的同义词。
DATA
#  如果程序文件中包含内容为__END__的行，那么这个常量表示该行后所有的文本行的流，
#  如果程序文件没有定义这样的行，那么这个常量未定义。
ENV
#  它是一个对象，其行为像一个哈希对象，可以通过它访问解释器中可用的环境变量。
FALSE
#  false的同义词，已被废弃。
NIL
#  nil的同义词，已被废弃。
RUBY_PATCHLEVEL
#  用于指示ruby解释器补丁号的字符串。
RUBY_PLATFORM
#  用于指示解释器运行平台的的字符串。
RUBY_RELEASE_DATE
#  用于指示ruby解释器发布日期的字符串。
RUBY_VERSION
#  用于指示解释器支持的ruby语言版本号的字符串。
STDERR
#  标准错误流，是$stderr变量的默认值。
STDIN
#  标准输入流，是$stdin变量的默认值。
STDOUT
#  标准输出流，是$stdout变量的默认值。
TOPLEVEL_BINDING
#  一个binding对象，用于表示顶级范围的绑定。
TRUE
#  true的同义词，已被废弃。
#-------------------------------------------------------------------------------
# 
# ==============
# |  全局变量  |
# ==============
# 全局设置
# ~~~~~~~~
$*
#  ARGV常量的只读同义词。
$$
#  当前ruby进程的ID。
$?
#  最后一个结束程序的退出状态，它是只读且线程局部的。
$DEBUG,$-d
#  如果在命令行设置了-d或--debug属性，这两个变量值为true。
$LOADED_FEATURES,$"
#  程序加载的文件。
$LOAD_PATH,$:,$-I
#  程序加载路径。
$PROGRAM_NAME,$0
#  程序文件名。
$VERBOSE,$-v,$-w
#  如果命令行设置了-v,-w,--verbose选项，那么它们的值为true，
#  如果设置了-W0选项，则值为nil，否则为false。
#  如果设置该变量值为nil，则忽略所有警告。

# 异常处理全局变量
# ~~~~~~~~~~~~~~~~
$!
#  最后抛出的异常对象。
$@
#  最后一个异常对象的调用堆栈，等价于$!.backtrace，它是线程局部的。

# 流和文本处理的全局变量
# ~~~~~~~~~~~~~~~~~~~~~~
$_
#  Kernel.readline和Kernel.gets所读取的最后一个字符串，线程局部且方法局部。
$<
#  ARGF流的一个只读同义词，如果在命令行中指定了多个文件，它就像这些文件连接起来的
#  一个虚拟IO对象，如果没有指定文件，它代表标准输入IO对象。
#  Kernel模块的文件读取方法从这个流中进行读取。
$stdin 
#  标准输入流。它的初始值是常量STDIN，不过很多ruby程序不从它读取信息，
#  而是使用ARGF,$<进行读取。
$stdout,$>
#  标准输出流。Kernel.puts,Kernel.print,Kernel.printf的默认输出流。
$stderr 
#  标准错误流。默认值为STDERR。
$FILENAME
#  ARGF当前读取的文件名，等价于ARGF.filename。
$.
#  从当前输入文件中最后读取的行号。等价于ARGF.lineno。
$/,$-0
#  输入记录分隔符(input record separator)，gets和readline方法用来确定行边界。
$\
#  输出记录分隔符(Output record separator)，每次调用print方法会打印这个分隔符。
$,
#  输出字符分隔符(output field separator)，print方法打印输出时各个参数间的分隔符，
#  也是Array.join方法默认的分隔符。
$;,$-F
#  字符分隔符(field separator)，split方法用来分割字符串。
$F
#  当ruby解释器使用-a选项并搭配-n或-p选项进行启动时，解释器将定义这个变量。

# 模式匹配全局变量
# ~~~~~~~~~~~~~
$~
#  最后一次模式匹配操作生成的MatchData对象，它是线程局部且方法局部的。
$&
#  最近匹配的文本，等价于$~[0]，它是线程局部和方法局部的。
$`
#  最新匹配文本之前的字符串，等价于$~.pre_match。它是线程局部且方法局部的。
$'
#  最新匹配文本之后的字符串，等价于$~.post_match。它是线程局部且方法局部的。
$+
#  最后一次模式匹配中最后一个成功匹配分组的字符串。它是线程局部且方法局部的。
  
# 命令行选项全局变量
# ~~~~~~~~~~~~~~~
$-a
#  如果指定解释器选项-a，其值为true，否则为false。
$-i
#  如果未指定解释器选项-i，其值为nil，否则，其值为-i所指定的备份文件后缀名。
$-l
#  如果指定-l选项，其值为true。
$-p
#  如果指定解释器选项p，其值为true，否则为false。
$-W
#  设置verbose级别，
#  -W0: 不设置-w,-v,--verbose，
#  -W1: 设置-w,-v,--verbose中任一个，
#  -W2: 设置-w,-v,--verbose全部。

#------------------------------------------------------------------------------
# 
# ============
# |  全局函数  |
# ============
# 关键字函数
# ~~~~~~~~
# block_given?    iterator?   loop    require
# callcc          lambda      proc    throw
# catch           load        raise

# 文本输入输出和操作函数
# ~~~~~~~~~~~~~~~~~~
# format          print       puts    sprintf
# gets            printf      readline
# p               putc        readlines

# os方法
# ~~~~~
# `               fork        select   system   trap
# exec            open        syscall  test 

# 警告，失败和退出
# ~~~~~~~~~~~~~~~~
# abort           at_exit     exit!    fail     warn

# 反射函数
# ~~~~~~~
# binding           set_trace_func    
# caller            singleton_method_added
# eval              singleton_method_removed
# global_variables  singleton_method_undefined
# local_variables   trace_var
# method_missing    untrace_var
# remove_instance_variable

# 转换函数
# ~~~~~~~
# Array     Float     Integer    String

# 杂项Kernel函数
# ~~~~~~~~~~~~~
# autoload          rand            srand
# autoload?         sleep 
#------------------------------------------------------------------------------
#
# ===========
# |  Linux  |
# ===========
# 调用操作系统命令
# ~~~~~~~~~~~~~
# os = `uname`
# os = %x{uname}
# os = Kernel.`("uname")

# 启动一个管道进行读写
# ~~~~~~~~~~~~~~~~
pipe = open("|echo *.xml")
files = pipe.readline
pipe.close

# Kernel.system
# ~~~~~~~~~~~~~
# 如果传入单个字符串，它在外壳中执行这个字符串所表示的命令，如果成功返回true，如果失败返回false。
# 如果传入多个字符串，第一个参数是程序名，其余的参数则成为它的命令行参数。

# 创建子进程
# ~~~~~~~~
pid = fork
if (pid)
  puts "Hello from parent process: #$$"
  puts "Created child process #{pid}"
else
  puts "Hello from child process: #$$"
end

# 子进程和父进程通信
# ~~~~~~~~~~~~~~~
open("|-", "r+") do |child|
  if child
    # This is the parent process
    child.puts("Hello child")       # send to child
    response  = child.gets          # read from child
    puts "Child said: #{response}"
  else
    # This is the child process
    from_parent = gets              # read from parent
    STDERR.puts "Parent said: #{from_parent}"
    puts "Hi Mom!"                  # send to parent
  end
end 
  
# Kernel.exec
# ~~~~~~~~~~~
# 参数和Kernel.system一样，但是不会有返回值。
open("|-", "r") do |child|
  if child 
    # This is the parent process
    files = child.readlines         # read the output of our child
    child.close
    puts files
  else
    # This is the child process
    exec("/bin/ls", "-l")           # run another executable
  end
end 
#-------------------------------------------------------------------------------
# 
# ==============
# |  捕获信号  |
# ==============
# 异步信号：shell向程序发送信号，控制程序的运行状态。
#
# Kernel.trap 
# ~~~~~~~~~~~
# 捕获信号并定义自己的信号处理程序。
trap("SIGINT") { puts "Ignoring SIGINT" }
# ------------------------------------------------------------------------------
#
# ==============
# |  结束程序  |
# ==============
#
# 1. Kernel.exit 
# ~~~~~~~~~~~~~~
# 退出程序，并执行END块和Kernel.at_exit注册的处理方法。
#
# 2. Kernel.exit!
# ~~~~~~~~~~~~~~~
# 退出程序，不执行相关操作。
#
# 3. Kernel.abort
# ~~~~~~~~~~~~~~~
# 向标准输出流打印指定的错误信息，然后调用exit(1)。
#
# 4. Kernel.fail 
# ~~~~~~~~~~~~~~
# raise的同义词。
#
# 5. Kernel.warn
# ~~~~~~~~~~~~~~
# 向标准错误流打印一个警告消息。
  









