#
# ==================
# |  线程生命周期  |
# ==================


# 主线程
# ~~~~~~
# Ruby解释器在主线程完成时会停止运行，即使在主线程创建用的线程仍在运行时也是如此，
# 因此，必须保证主线程在其他线程仍在运行时不会结束。
# 一种方法是采用无限循环方式实现主线程，
# 另一种方式是明确等待其他线程完成操作。
# 
# Thread.value
# ~~~~~~~~~~~~
# Thread.new创建一个线程，原先的线程从Thread.new的调用中返回并且继续执行后续的语句
# 当Thread.new代码块中的语句被执行完毕，新线程就会结束
# 通过Thread对象的value方法可以获得代码块的返回值
# 如果在线程结束之前调用value方法，那么调用者将被阻塞，直到该线程返回一个值为止

# This method expects an array of  filenames. 
# It returns an array of strings holding the content of the named files.
# The method creates one thread for each named file. 
def readlines(filenames)
  # Create an arry of threads from the array of filenames. 
  # Each thread starts reading a file. 
  threads = filenames.map do |f|
    Thread.new { File.read(f) }
  end

  # Now create an array of file contents by calling the value
  # method of each thread. This method blocks, if necessary,
  # until the thread exits with a value.
  threads.map {|t| t.value }
end 

# Thread.join
# ~~~~~~~~~~~
# Wait for all threads (other than the current thread and 
# main thread) to stop running.
# Assumes that no new threads are started while waiting.
def join_all
  main = Thread.main        # The main thread 
  current = Thread.current  # The current thread
  all = Thread.list         # All threads still running 
  # Now call join on each thread
  all.each {|t| t.join unless t == current or t == main }
end 

# 线程和未处理的异常 
# ~~~~~~~~~~~~~~~~~~
# 如果在主线程中抛出异常并且没有被处理，将打印一条消息并退出。
# 如果其他线程中有未处理的异常，那么只有这个线程被停止，不会打印消息。
# 如果线程t因为一个为处理的异常而中止，而另外一个线程s调用了t.value或t.join 
# 方法，那么t中产生的异常将在线程s中被抛出。
#
# 使所有的线程的未处理异常都使解释器退出：
# Thread.abort_on_exception = true 
#
# 使某个特定的线程的未处理异常使得解释器退出：
# t = Thread.new {...}
# t.abort_on_exception = true 

# ------------------------------------------------------------------------------
#
# ================
# |  线程和变量  |
# ================
#
# 线程私有变量
# ~~~~~~~~~~~~
# 在代码块中定义的变量是私有的，对其他线程是不可见的。

n = 1
while n <= 3
  # Get a private copy of the current value of n in x
  Thread.new(n) {|x| puts x }
  n += 1
end 
# 或者
1.upto(3) {|n| Thread.new { puts n }}

# 线程局部变量
# ~~~~~~~~~~~~
# 一些特殊的全局变量是线程局部的，在不同的线程中有着不同的值，对其他线程可见。
# 例如$SAFE,$~变量。
# 如果两个线程同时进行正则表达式匹配，它们看到的$~值是不同的。

# 例如，假设我们创建了一些线程从一个web服务器下载文件，主线程用于监视下载进度。
Thread.current[:progress] = bytes_received
total = 0
download_threads.each {|t| total += t[:progress]  if t.key?(:progress)}

# ------------------------------------------------------------------------------
#
# ==============
# |  线程调度  |
# ==============
# 线程共享CPU的过程被称为线程调度。

# 线程优先级
# ~~~~~~~~~~
# 一个线程只有在没有更高优先级的线程等待时才可能被CPU执行。
# Thread对象的priority=和priority方法用来设置和查询线程优先级。
# 新创建的线程的优先级与创建它的线程相同，主线程将以优先级0启动。

# 抢占式调度和Thread.pass方法
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 抢占式调度：每个同级别的线程都可以被执行固定的时间。
# 非抢占式调度：一旦一个线程开始执行，除非它睡眠，IO阻塞或有更高级别的线程醒来，
# 否则它会一直运行下去。
#
# 如果一个计算绑定(compute-bound)的线程要运行很长时间，那么在一个非阻塞的调度器
# 上，它会让其他线程感到“饥饿”，其他线程无法获得运行的机会，要避免这一问题，
# 耗时的计算机绑定应该定期调用Thread.pass方法，让别的线程有机会获得CPU。
#
# ------------------------------------------------------------------------------
#
# ==============
# |  线程状态  |
# ==============
# 
# ------------------------------------------------------------------------------
#   活动状态  |  可运行： 要么正在运行，要么已经准备好在下次CPU资源可用时运行
#             +-----------------------------------------------------------------
#             |  休眠： 要么是因为I/O操作而休眠，要么被自身中止
# ------------+-----------------------------------------------------------------
#   非活动状态|  正常退出
#             +-----------------------------------------------------------------
#             |  异常中止
# ------------+-----------------------------------------------------------------
#   过渡状态  |  正在中止
# ------------+-----------------------------------------------------------------
#
# 查询线程状态
# ~~~~~~~~~~~~
# alive?
# 查询线程是否处于可运行状态或休眠状态。
#
# stop?
# 查询线程是否出于正常退出状态或休眠状态。
#
# current
# 查询正在占用CPU运行的线程。
#
# status
# 查询线程的状态：
#   "sleep": sleeping or waiting on I/O
#   "run": executing
#   "aborting": aborting
#   false: terminated normally
#   nil: terminated with an exception
#
# 状态转换：暂停，唤醒和杀死线程
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Thread.stop 
# 使线程进入休眠状态，执行另外一个线程。
#
# Kernel.sleep
# 使线程进入休眠状态，在一定秒数后被唤醒。
#
# Thread#wakeup
# 唤醒线程，等待被调度。
#
# Thread#run 
# 唤醒线程，同时被调度。
#
# Thread#exit 
# Thread#kill
# Thread#terminate 
# 使线程正常结束，同时执行ensure从句。 
#
# Thread#exit!
# Thread#kill!
# Thread#terminate!
# 使线程正常结束，同时不执行ensure从句。
#
# Kernel#raise
# 使线程异常退出。
#
# ------------------------------------------------------------------------------
#
# ======================
# |  列举线程和线程组  |
# ======================
#
# Thread.list
# ~~~~~~~~~~~
# 返回所有活跃线程的Thread对象数组。
# 当一个线程结束时，它从这个数组中删除。 
#
# ThreadGroup
# ~~~~~~~~~~~
# 线程组，用于组织线程的结构。
#
# 创建线程组并加入线程
group = ThreadGroup.new 
3.times {|n| group.add(Thread.new{})}

# Thread#group
# 查询线程属于的组。

# ThreadGroup.list 
# 返回组中所有的活动线程。

# ThreadGroup#enclose
# 封闭线程组，无法在加入或删除线程。

# ------------------------------------------------------------------------------
#
# ==================
# |  并发读取文件  |
# ==================
# Read files concurrently. Use with the "open-uri" module to fetch URLs.
# Pass an array filenames. Returns a hash mapping filenames to content.
def conread(filenames)
  h = {}                # Empty hash of results 

  # Create one Thread for each file 
  filenames.each do |filename|
    h[filename] = Thread.new do 
      open(filename) {|f| f.read }
    end 
  end 

  # Iterate through the hash, waiting for each thread to complete.
  # Replace the thread in hash with its value (the file contents)
  h.each_pair do |filename, thread|
    begin
      h[filename] = thread.value 
    rescue
      h[filename] = $!
    end 
  end 
end 

# ------------------------------------------------------------------------------
#
# ======================
# |  多线程多路服务器  |
# ======================
require 'socket'

# This method expects a socket connected to a client.
# It reads line from the client, reverse them and sends them back.
# Multiple threads may run this method at same time.
def handle_client(c)
  while true 
    input = c.gets.chop       # Read a line of input from the client 
    break if !input           # Exit if no more input 
    break if input == "quit"  # or if the client asks to.
    c.puts(input.reverse)     # Otherwise, respond to client.
    c.flush                   # Force our output out 
  end 
  c.close                     # Close the socket
end 

server = TCPServer.open(2000) # Listen on port 2000 

while true                    # Servers loop forever 
  client = server.accept      # Wait for a client to connect 
  Thread.start(client) do |c| # Start a new Thread
    handle_client(C)          # And handle the client on that thread
  end 
end 

# ------------------------------------------------------------------------------
#
# ================
# |  并发迭代器  |
# ================
# 并发map
# ~~~~~~~
module Enumerable             # Open the Enumerable module
  def conmap(&block)          # Define a new method that excepts a block
    threads = []              # Start with an empty array of threads 
    self.each do |item|       # For each enumerable item 
      # Invoke the block in a new thread, and remember the thread
      threads << Thread.new { block.call(item) }
    end 
    # Now map the array of threads to their values 
    threads.map {|t| t.value }    # And return the array of values 
  end 
end 

# 并发each
# ~~~~~~~~
module Enumerable
  def coneach
    map {|item| Thread.new {yield item}}.each {|t| t.join}
  end 
end 

# ------------------------------------------------------------------------------
#
# ================
# |  互斥和死锁  |
# ================
#
# 互斥锁Mutex
# ~~~~~~~~~~~
# A BankAccount has a name, a checking amount, and a savings amount.
class BankAccount
  def init(name, checking, savings)
    @name,@checking,@savings = name,checking,savings
    @lock = Mutex.new 
  end 

  # Locking account and transfer money from savings to checking
  def transfer_from_savings(x)
    @lock.synchronize {
      @savings -= x
      @checking += x
    }
  end 

  # Locking account and report current balances 
  def report
    @lock.synchronize {
      "#@name\nChecking: #@checking\nSavings: #@savings"
    }
  end 
end 

# 死锁
# ~~~~
# Classic deadlock: two threads and two locks 
m,n = Mutex.new, Mutex.new 

t = Thread.new {
  m.lock
  puts "Thread t locked Mutex m"
  sleep 1
  puts "Thread t waiting to lock Mutex n"
  n.lock 
}

s = Thread.new {
  n.lock
  puts "Thread s locked Mutex n"
  sleep 1
  puts "Thread s waiting to lock Mutex n"
  m.lock
}

t.join 
s.join 

# ------------------------------------------------------------------------------
#
# =======================
# |  Queue和SizedQueue  |
# =======================
module Enumerable
  # Concurrent inject: expects an initial value and two Procs
  def conject(initial, mapper, injector)
    # Use a Queue to pass values from mapping threads to injector thread
    q = Queue.new 
    count = 0               # How many items?
    each do |item|          # For each item 
      Thread.new do         # Create a new thread
        q.enq(mapper[item]) # Map and enqueue mapper value 
      end 
      count += 1            # Count items 
    end 

    t = Thread.new do         # Create injector thread 
      x = initial             # Start with specified initial value 
      while (count > 0)       # Loop once for each item 
        x = injector[x,q.deq] # Dequeue value and inject 
        count -= 1            # Count down 
      end 
      x                       # Thread value is injected value 
    end 

    t.value                   # Wait for injector thread and return its value 
  end 
end 

a = [-2,-1,0,1,2]
mapper = lambda {|x| x*x}
injector = lambda {|total,x| total+x}
a.conject(0, mapper, injector)

# ------------------------------------------------------------------------------
#
# =======================
# |  ConditionVariable  |
# =======================
# ConditionVariable.new
# ~~~~~~~~~~~~~~~~~~~~~
# 创建一个条件变量对象。
#
# ConditionVariable#wait
# ~~~~~~~~~~~~~~~~~~~~~~
# 可以让一个线程等待这个条件。
#
# ConditionVariable#signal
# ~~~~~~~~~~~~~~~~~~~~~~~~
# 唤醒一个等待线程。
#
# ConditionVariable.broadcast
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 唤醒所有等待线程。 
#
# Exchanger
# ~~~~~~~~~
class Exchanger
  def initialize
    # These variables will hold the two values to be exchanged.
    @first_value = @second_value = nil 
    # This Mutex protects access to the exchange method.
    @lock = Mutex.new 
    # This Mutex allows us to determine whether we're the first or 
    # second thread to call exchange.
    @first = Mutex.new 
    # This ConditionVariable allows the first thread to wait for the 
    # arrival of the second thread.
    @second = ConditionVariable.new 
  end 
  
  # Exchange this value for the value passed by other thread.
  def exchange(value)
    @lock.synchronize do        # Only one thread can call this method at a time 
      if @first.try_lock        # We are the first thread
        @first_value = value    # Store the first thread's argument 
        # Now wait until the second thread arrives.
        # This temporarily unlocks the Mutex while we wait, so 
        # that the second thread can call this method, too 
        @second.wait(@lock)     # Wait for second thread
        @first.unlock           # Get ready for the next exchange 
        @second_value           # Return the second thread's value 
      else                      # Otherwise, we're the second thread
        @second_value = value   # Store the second value 
        @second.signal          # Tell the first thread we're here
        @first_value            # Return the first thread's value 
      end 
    end 
  end 
end 

# ------------------------------------------------------------------------------

