require 'socket'

hostname = 'localhost'
port = 2000
path = '/index.html'				# The file we want

# This is the HTTP request we send to fetch a file
request = "GET #{path} HTTP/1.0\r\n\r\n"

s = TCPSocket.open(hostname, port)
s.puts request

while line = s.gets		# Read lines from the port
	puts line.chop		# And print with platform line terminator
end
s.close					# Close the socket when done