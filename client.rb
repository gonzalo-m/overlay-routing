require 'socket'

class Client

	def initilize(ip, port)
		@server = TCPSocket.open(ip, port)
		@request = nil
		@response = nil
		receive
		send
		@request.join
		@response.join
	end


	def receive
		@response = Thread.new do
			loop {
				msg = @server.gets.chomp
				puts "#{msg}"
			}
		end
	end


	def send
		@request = Thread.new do
			loop {
				msg = STDIN.gets.chomp
				@server.pust(msg)
			}
		end
	end
end

ip = '10.0.0.20'
port = 7000
s = Client.new(ip, port)

# while line = gets
# line = gets
# puts line.chop
# end

# msg = 'hi'
# s.puts(msg)

# while line = s.gets
#   print line
# end

# s.send 'Hi from client'
# STDOUT.flush
# msg = s.gets
# print msg
# s.puts Thread.current.object_id


# s.close