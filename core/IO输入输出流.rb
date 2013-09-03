# 
# ============
# |  打开流  |
# ============
#
# 打开文件
# ~~~~~~~~
f = File.open("data.txt", "r")
out = File.open("data.txt", "w")
#
#   方式          |  描述                
# ----------------+-------------------------------------------------------------
#   "r"           | 读方式打开文件
# ----------------+-------------------------------------------------------------
#   "r+"          | 读写方式打开文件，读写直接置于文件起始处，如果不存在导致失败
# ----------------+-------------------------------------------------------------
#   "w"           | 写方式打开文件，会创建一个新文件，或截取一个已有文件
# ----------------+-------------------------------------------------------------
#   "w+"          | 允许读文件
# ----------------+-------------------------------------------------------------
#   "a"           | 追加写方式，如果文件存在，则在尾部追加写入的新内容
# ----------------+-------------------------------------------------------------
#   "a+"          | 允许读文件
#
# 如果File.open带有代码块，则将打开的文件流对象传递给代码块，
# 代码块结束后关闭文件流，同时代码块的返回值作为File.open的返回值。
#
#
# Kernel.open
# ~~~~~~~~~~~
# 如果文件名以|打头，它就被视作一个系统命令，
# 返回的流被读写该命令的进程使用。
# How long has the server been up?
uptime = open("|uptime") {|f| f.gets }

# 如果加载了open-uri库，
# 那么open方法可以用于读取http和ftp的URL。
require 'open-uri'
f = open("http://www.163.com")
webpage = f.read
f.close


# StringIO类
# ~~~~~~~~~~
# 用于对字符串进行流读写
require 'stringio'
input = StringIO.open("now is the time")
buffer = ''
output = StringIO.open(buffer, "w")


# 预定义流
# ~~~~~~~~
# STDIN($stdin): 标准输入流
# STDOUT($stdout): 标准输出流
# STDERR($stderr): 标准错误流
# ARGF($<): 控制台流，命令行参数保存在ARGV($*)数组中。
# DATA: 用于读取Ruby脚本后面出现的文本，
#       当Ruby脚本包含__END__标记时，它表示程序文本的结束，
#       该标记后的任何文本将被DATA流读取。

# ------------------------------------------------------------------------------
#
# ==================
# |  流和编码方式  |
# ==================
#
# 每个流可以有两个关联的编码方式，内部编码和外部编码，
# 可以通过IO对象的external_encoding和internal_encoding方法获得。
# 外部编码是存储在文件中的文本的编码方式，
# 内部编码是Ruby中用于表示文本的编码方式。
# 在读入文本时，Ruby将从外部编码方式转换为内部编码方式，
# 在输出文本时，从内部编码方式转为外部编码方式。
#
# set_encoding
# ~~~~~~~~~~~~
# 可被任何IO对象使用，
# 第一个参数为外部编码方式，
# 第二个参数为内部编码方式。
f.set_encoding("iso-8859-1", "utf-8")   # Latin-1, transcoded to UTF-8
f.set_encoding("iso-8859-1:utf-8")      # Same as above 
f.set_encoding(Encoding::UTF-8)         # UTF-8 text 

# 打开文件时指定编码方式
# ~~~~~~~~~~~~~~~~~~~~~~
in = File.open("data.txt","r:utf-8")    # read utf-8 text 
out = File.open("log","a:utf-8")        # write utf-8 text
in = File.open("data.txt", "r:iso8859-1:utf-8") # Latin-1 transcoded to UTF-8

# 读取二进制数据
# ~~~~~~~~~~~~~~
# 必须显式指明需要为编码的字节，否则会得到默认外部编码方式的字符。
# 可以使用"r:binary"方式打开文件，也可以在打开文件后Encoding::BINARY参数调用set_encoding方法。

# ------------------------------------------------------------------------------
#
# ============
# |  读取流  |
# ============
#  
# 读取文本行
# ~~~~~~~~~~
lines = ARGF.readlines
line = DATA.readline 
print l while l = DATA.gets 
DATA.each {|line| print line }
DATA.each_line 
DATA.lines        
# 
# 在文件处于EOF时，gets方法返回nil，readline方法抛出EOFError异常。
# gets和readline方法隐式的把全局变量$_赋值为返回的文本行。
# 每次读取换行符分隔的一行，$/用于存放换行符。
# 可以用lineno来获取最近读取的行号。
DATA.lineno = 0   # Start from line 0, even though data is at end of file 
DATA.readline     # Read one line of data 
DATA.lineno       # => 1
$.                # => 1

# 读取整个文件
# ~~~~~~~~~~~~
# IO.read读取整个文件到字符串，
# IO.readlines读取整个文件到文本行数组，
# IO.foreach迭代文件的每一行。
data = IO.read("data")
data = IO.read("data", 4, 2)
data = IO.read("data", nil, 6)

# Read lines into an array
words = IO.readlines("/usr/share/dict/words")

# Read lines one at a time and initialize a hash 
words = {}
IO.foreach("/usr/share/dict/words") {|w| words[w] = true }

# 实例方法File#read具有类似的作用
f = File.open("data.txt")
text = f.read 
f.close 

# 读取字节和字符
# ~~~~~~~~~~~~~~
# getc: 读取一个字符，包括多字节字符，
# getbyte: 读取一个字节，
# readchar: 读取一个字符，包括多字节字符，
# readbyte: 读取一个字节，
# getbyte,getc,gets在EOF时，返回nil，
# readbyte,readchar,readline在EOF时，抛出EOFError。

# ungetc
# ~~~~~~
# 将字符推入到缓冲区
f = File.open("data", "r:binary")  
c = f.getc                         
f.ungetc(f)
c = f.readchar 

# each_byte
# ~~~~~~~~~
# 把流中的每个字节传给相关的代码块
f.each_byte {|b| ... }    # synonym f.bytes

# ------------------------------------------------------------------------------
#
# ============
# |  写入流  |
# ============
#  
#  putc
#  ~~~~
#  用于向流中写入一个字节或字符，不能用于多字节字符。
o = STDOUT
o.putc(65)    # => print "A"
o.putc("B")   # => print "B"
o.putc("CD")  # => print "C"

# 写入任意字符串
# ~~~~~~~~~~~~~~
o = STDOUT
# String output 
o << x              # output x.to_s
o << x << y         # output x.to_s + y.to_s
o.print             # output $_ + $\
o.print s           # output s.to_s + $\
o.print s,t         # output s.to_s + t.to_s + $\   记录分隔符:$\
o.printf fmt,*args  # output fmt%[args]
o.puts              # output newline
o.puts x            # output x.to_s.chomp plus newline
o.puts x,y          # output x.to_s chomp plus newline y.to_s chomp plus newline
o.write s           # output s.to_s, returns s.to_s length
o.syswrite s        # low-level version of write 

# ------------------------------------------------------------------------------
#
# ==================
# |  随机访问方法  |
# ==================
f = File.open("test.txt")
f.pos         # => 0
f.pos = 10    # => 10
f.tell        # => 10
f.rewind      
f.seek(10, IO::SEEK_SET)  # skip to absolute position 10 
f.seek(10, IO::SEEK_CUR)  # skip to bytes from current position
f.seek(-10, IO::SEEK_END) # skip 10 bytes from the end 
f.seek(0, IO::SEEK_END)   # skip to very end of file 
f.eof?                    # => true 

# 如果在程序中使用了syswrite或sysread，则不能使用seek方法，
# 而要用sysseek方法，每次返回文件指针当前的位置。
pos = f.sysseek(0, IO::SEEK_CUR)  # Get current position
f.sysseek(0, IO::SEEK_SET)        # Rewind stream 
f.sysseek(pos, IO::SEEK_SET)      # Return to original position

# ------------------------------------------------------------------------------
#
# ========================
# |  关闭，清除和测试流  |
# ========================
#
# 使用代码块关闭流
# ~~~~~~~~~~~~~~~~
File.open("test.txt") do |f|
  # Use stream f here
end 

# 使用ensure关闭流
# ~~~~~~~~~~~~~~~~
begin 
  f = File.open("test.txt")
  # use stream here 
ensure
  f.close if f
end 

# 关闭socket流
# ~~~~~~~~~~~~
# socket使用了IO对象，它在内部分别使用进行读写的流，
# 可以使用close_read和close_write方法对它们进行关闭。

# 缓冲机制
# ~~~~~~~~
# Ruby的输出方法(除了syswrite)都会进行缓冲，
# 输出缓冲区在适当的时机被清空，比如在输出一个换行符或从一个相应的流中读取数据。
out = STDOUT
out.print 'wait>'   # Display a prompt
out.flush           # Manually flush output buffer to os
sleep(1)            # Prompt appears before we go to sleep

out.sync = true     # Automatically flush buffer after every write 
out.sync = false    # Don't Automatically flush
out.sync            # Return current sync mode 
out.fsync           # Immediately writes all buffered data in ios to disk

# 流的状态检测
# ~~~~~~~~~~~~
f.eof?
f.closed?
f.tty?
# tty?: 如果流连接的交互设备是终端窗口或键盘，
#       返回true，如果流是非交互模式，如文件，管道或套接字，则返回false。
#       可用于当STDIN被重定向到文件时，不在显示提示用户输入的消息。

# ------------------------------------------------------------------------------

