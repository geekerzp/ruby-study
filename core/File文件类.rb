#
# ================
# |  文件和目录  |
# ================
#
full = '/home/geekerzp/bin/ruby.exe'
file = File.basename(full)    # => 'ruby.exe'
File.basename(full, '.exe')   # => 'ruby'
# 获取文件目录
# ~~~~~~~~~~~~
dir = File.dirname(full)      # => '/home/geekerzp/bin'
File.split(full)              # => ["/home/geekerzp/bin", "ruby.exe"]
File.extname(full)            # => '.exe'
File.extname(file)            # => '.exe'
File.extname(dir)             # => ''
File.join('home', 'geekerzp') # => 'home/geekerzp': relative
File.join('','home','geekerzp')   # => '/home/geekerzp':absolute 

Dir.chdir('/usr/bin')         # Current working directory is "/usr/bin"
File.expand_path("ruby")      # => "/usr/bin/ruby"
File.expand_path("~/ruby")    # => "/home/geekerzp/ruby" 
File.expand_path("~geekerzp/ruby")  # => "/home/geekerzp/ruby"
File.expand_path("ruby", "/usr/local/bin")  # => "/usr/local/bin/ruby"
File.expand_path("ruby", "../local/bin")    # => "/usr/local/bin/ruby"

# File.identical?
# ~~~~~~~~~~~~~~~
# 判断两个路径是否指向同一个文件，
# 指向同一个文件，同时文件存在则返回真。
File.identical?("ruby", "ruby")           # => true 
File.identical?("ruby", "/usr/bin/ruby")  # => true 
File.identical?("ruby", "../bin/ruby")    # => true
File.identical?("ruby", "ruby1.9.1")      # => true 

# File.fnmatch
File.fnmatch("*.rb", "hello.rb")          # => true 
File.fnmatch("*.[ch]", "ruby".c)          # => true 
File.fnmatch("?.txt", "ab.txt")           # => false 
flags = File::FNM_PATHNAME | File::FNM_DOTMATCH 
File.fnmatch("lib/*.rb", "lib/a.rb", flags)   # => true 
File.fnmatch("lib/*.rb", "lib/a/b.rb", flags) # => false
File.fnmatch("lib/**/*.rb", "lib/a.rb", flags)# => true 
File.fnmatch("lib/**/*.rb", "lib/a/b.rb", flags)  # => true 

# ------------------------------------------------------------------------------
#
# ==============
# |  列举目录  |
# ==============
#
# 返回全部文件
# ~~~~~~~~~~~~
# Get the names of all files  in the config/ directory
filenames = Dir.entires("config")
Dir.foreach("config") {|filename| ... }

# 返回匹配的文件
# ~~~~~~~~~~~~~~
Dir['*.data']
Dir['ruby.*']
Dir['?']
Dir['*.[ch]']
Dir['*.{java,rb}']
Dir['*/*.rb']
Dir['**/*.rb']

Dir.glob('*.rb') {|f| ... }
Dir.glob('*')
Dir.glob('*',File::FNM_DOTMATCH)

# 改变当前工作目录
# ~~~~~~~~~~~~~~~~
puts Dir.pwd
Dir.chdir('..')
home = Dir.pwd
# 两个线程不能同时操作Dir.chdir方法。

# ------------------------------------------------------------------------------
#
# ==============
# |  测试文件  |
# ==============
#
f = "/usr/bin/ruby"

# File existence and types.
File.exists? f    # => true 
File.file? f      # => true 
File.directory? f # => false 
File.symlink? f   # => true

# File size methods. Use File.truncate to set file size.
File.size f       # => 5572
File.size? f      # => 5572 
File.zero? f      # => false 

# File permissions. Use File.chmod to set permissions (system dependent)
File.readable? f  # => true 
File.writable? f  # => false 
File.executable? f# => true 
File.world_readable?    # => 493
File.world_writable?    # => nil 

# File times/dates. Use File.utime to set times.
File.mtime(f)     # => 2012-10-17 05:14:16 +0800
File.atime(f)     # => 2013-01-31 13:25:34 +0800

# File.ftype
# ~~~~~~~~~~
File.ftype("/usr/bin/ruby")       # => "link"
File.ftype("/usr/bin/ruby1.9.1")  # => "file"
File.ftype("/usr/lib/ruby")       # => "directory"
File.ftype("/usr/bin/ruby3.0")    # => Errno::ENOENT: No such file or directory 

# File.stat,File.lstat  
# ~~~~~~~~~~~~~~~~~~~~
# 对于符号链接，stat返回所链接文件的信息，而lstat返回链接本身的信息。
s = File.stat("/usr/bin/ruby")
s.file?     # => true 
s.directory # => false 
s.ftype     # => "file"
s.readable? # => true 
s.writable? # => false 
s.executable? # => true 
s.size      # => 5572 
s.atime     # => 2013-01-31 13:25:34 +0800

# Kernel.test
# ~~~~~~~~~~~
# 为了和Unix的shell命令test保持兼容而存在。
# Testing single files 
test ?e, "/usr/bin/ruby"  # File.exist? "/usr/bin/ruby"
test ?f, "/usr/bin/ruby"  # File.file? "/usr/bin/ruby"
test ?d, "/usr/bin/ruby"  # File.directory? "/usr/bin/ruby"
test ?r, "/usr/bin/ruby"  # File.readable? "/usr/bin/ruby"
test ?w, "/usr/bin/ruby"  # File.writable? "/usr/bin/ruby"
test ?M, "/usr/bin/ruby"  # File.mtime "/usr/bin/ruby"
test ?s, "/usr/bin/ruby"  # File.size? "/usr/bin/ruby"

# Comparing two files f and g
test ?-, f, g             # File.identical(f,g)
test ?<, f, g             # File.mtime(f) < File.mtime(g)
test ?>, f, g             # File.mtime(f) > File.mtime(g)
test ?=, f, g             # File.mtime(f) = File.mtime(g)

# ------------------------------------------------------------------------------
#
# ==================================
# |  创建，删除，重命名文件和目录  |
# ==================================
#
# 创建文件
# ~~~~~~~~
File.open("test", "w") {}
File.open("test", "a") {}

# 重命名
# ~~~~~~
File.rename("test", "test.old")

# 符号链接
# ~~~~~~~~
File.symlink("test.old", "oldtest")

# 硬链接
# ~~~~~~
File.link("test.old", "test2")

# 删除文件(即取消硬链接)
# ~~~~~~~~~~~~~~~~~~~~~~
File.delete("test2")
File.unlink("oldtest")  # synonym of delete
File.unlink("test.old")

# File.truncate
# ~~~~~~~~~~~~~
# 截取文件给定字节数
#
# File.utime
# ~~~~~~~~~~
# 修改文件的时间
#
# File.chmod
# ~~~~~~~~~~
# 修改文件的权限
f = "log.messages"
atime = mtime = Time.now 
File.truncate(f, 0)
File.utime(atime, mtime, f)
File.chmod(0600, f)

# Dir.mkdir
# ~~~~~~~~~
# 新建一个目录
#
# Dir.rmdir
# ~~~~~~~~~
# 删除一个目录，目录中没有文件
# 同义词Dir.delete, Dir.unlink 
#
Dir.mkdir("tmp")
File.open("tmp/f", "w") {}
File.open("tmp/g", "w") {}
File.delete(*Dir["tmp/*"]) 
Dir.rmdir("tmp")

# ------------------------------------------------------------------------------

