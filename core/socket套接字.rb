#
# ======================
# |  十分简单的客户端  |
# ======================
# 使用TCP/IP通信
require 'socket'
host, port = ARGV
s = TCPSocket.open(host, port)
while line = s.gets
  puts line.chop
end
s.close
# 用块来代替
require 'socket'
host, port = ARGV
TCPSocket.open(host, port) do |s|
  while line = s.gets
    puts line.chop 
  end   
end 

# ------------------------------------------------------------------------------
#
# ======================
# |  十分简单的服务器  |
# ======================
# 使用TCP/IP通信
require 'socket'
server = TCPServer.open(2000) # socket to listen on port 2000
loop {
  client = server.accept      # wait for a client to connect
  client.puts(Time.now.ctime) # send the time to the client 
  client.close                # Disconnect from the client
}

# ------------------------------------------------------------------------------
#
# ============
# |  数据报  |
# ============
# 使用UDP通信
#
# client
# ~~~~~~
require 'socket'

host, port, request = ARGV

ds = UDPSocket.new            # create datagram socket
ds.connect(host, port)        # connect to port on the host 
ds.send(request, 0)           # send the request string 
response,address = ds.recvfrom(1024)    # wait for a response (1kb max)
puts response                 # print the response 

# server 
# ~~~~~~
require 'socket'

port = ARGV[0]

ds = UDPSocket.new            # create new socket
ds.bind(nil, port)            # make it listen on the port 
loop do 
  request,address = ds.recvfrom(1024)
  response = request.upcase 
  clientaddr = address[3]
  clientname = address[2]
  clientport = address[1]
  ds.send(response, 0, clientaddr, clientport)
  # Log the client connection 
  puts "Connection from: #{clientname} #{clientaddr} #{clientport}"
end 

# ------------------------------------------------------------------------------
#
# ================
# |  复杂客户端  |
# ================
#
require 'socket'

host, port = ARGV

begin               # Begin for exception handling
  # Give the user soem feedback while connecting.
  STDOUT.print "Connecting..."    # Say what we're doing 
  STDOUT.flush                    # Make it visible right away
  s = TCPSocket.open(host, port)  # Connect 
  STDOUT.puts "done"              # And say we did it 

  # Now display information about the connection.
  local, peer = s.addr, s.peeraddr
  STDOUT.print "Connected to #{peer[2]}:#{peer[1]}" 
  STDOUT.puts " using local port #{local[1]}"

  # Wati just a bit, to see if the server sends any initial message.
  begin
    sleep(0.5)                    # Wait half a second
    msg = s.read_nonblock(4096)   # Read whatever is ready 
    STDOUT.puts msg.chop          # And display it 
  rescue SystemCallError
    # If nothing was ready to ready, just ignore the exception.
  end 

  # Now begin a loop of client/server interaction.
  loop do 
    STDOUT.print '> '   # Display prompt for local input 
    STDOUT.flush        # Make sure the prompt is visible 
    local = STDOUT.gets # Read line from the console
    break if !local     # Quit if no input from console 

    s.puts(local)       # Send the line to the server 
    s.flush             # Force it out 

    # Read the server's response and print out.
    # The server may send more than one line, so use readpartial
    # to read whatever it sends (as long as it all arrives in one chunk).
    response = s.readpartial(4096)    # Read server's response
    puts(response.chop)               # Display response to user 
  end 
rescue            # If anything goes wrong 
  puts $!         # Display the exception to the user 
ensure            # And no matter what happens
  s.close if s    # Don't forget to close the socket
end 

# ------------------------------------------------------------------------------
#
# ================
# |  多路服务器  |
# ================
#
# This server reads a line of input from a client, reverses 
# the line and sends it back. If the client sends the string "quit"
# it disconnect. It uses Kernel.select to handle multiple sessions. 

require 'socket'

server = TCPServer.open(2000)   # Listen on port 2000
sockets = [server]              # An array of sockets we'll monitor 
log = STDOUT                    # Send log messages to standard out 
while true                      # Servers loop forever 
  ready = select(sockets)       # Wait for a socket to be ready
  readable = ready[0]           # These sockets are readable 

  readable.each do |socket|       # Loop through readable sockets
    if socket == server           # If the server socket is ready 
      client = server.accept      # Accept a new client 
      sockets << client           # Add it to the set of sockets
      # Tell the client what and where it has connected.
      client.puts "Reversal service v0.01 running on #{Socket.gethostname}"
      log.puts "Accepted connection from #{client.peeraddr[2]}"
    else                          # Otherwise, a client is ready 
      input = socket.gets         # Read input from the client 

      # If no input, the client has disconnected
      if !input 
        log.puts "Client on #{client.peeraddr[2]} disconnected"
        sockets.delete(socket)    # Stop monitoring this socket
        socket.close              # Close it 
        next                      # And go on to the next 
      end 

      input.chop!                 # Trim client's input 
      if (input == "quit")        # If the client asked to quit 
        socket.puts("Bye!")       # Say goodbye 
        log.puts "Closing connection to #{socket.peeraddr[2]}"
        sockets.delete(socket)    # Stop monitoring the socket 
        socket.close              # Terminate the session 
      else                        # Otherwise, client is not quitting
        socket.puts(input.reverse)# So reverse input and send it back 
      end 
    end 
  end 
end 

    
