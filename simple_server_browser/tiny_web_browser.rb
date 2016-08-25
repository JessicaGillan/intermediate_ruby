require 'socket'
require 'json'

host = 'localhost'		# The web server
port = 2000							# Default HTTP port
path = '/index.html'				# The file we want

loop do
	puts "Which type of request would you like to send?"
	puts "1. GET"
	puts "2. POST"
	puts "3. Exit program"
	request = gets.chomp

	case request
	when "1" then request = "GET #{path} HTTP/1.0\r\n\r\n"
	when "2" 
		print "Enter name to register: "
		name = gets.chomp
		print "Enter email: "
		email = gets.chomp
		viking = { :viking => {:name => name, :email => email } }.to_json
		request = "POST #{path} HTTP/1.0\nContent Length: #{viking.size}\r\n\r\n#{viking}"
	when "3" then exit
	else puts "I don't know that request"
	end

	socket = TCPSocket.open(host, port)	# Connect to the server
	socket.print(request)				# Send request
	response = socket.read				# Read complete response

	# Split response at first blank line into headers and body
	headers, body = response.split("\r\n\r\n", 2)
	puts ""
	puts headers
	puts body 							# And display it
	puts ""
end
