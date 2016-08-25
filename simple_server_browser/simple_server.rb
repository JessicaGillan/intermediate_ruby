require 'socket'
require 'json'
require 'erb'

# create a container for our new method
class LayoutRenderer
end

server = TCPServer.open(2000) # Socket to listen on port 2000

Request = Struct.new(:command,:path,:http_vers,:content_length,:body)
Response = Struct.new(:status_code, :status_message, :content_length, :data)

def parse_request(request)
	command = request.scan(/GET|POST|DELETE|HEAD/)[0]
	path = request.scan(/\/(\S+\.[a-z]+)/)[0][0]
	http_vers = request.scan(/HTTP\/(\d\.\d)/)[0][0]
	content_length = request.scan(/\s(\d+)\s/)[0][0] unless request.scan(/\s(\d+)\s/).empty?

	return Request.new(command, path, http_vers, content_length)
end

def return_resource(resource_path)
	response = Response.new

	if File.exist?(resource_path)
		response[:status_code] = 200
		response[:status_message] = "OK"
		data = File.read(resource_path)
		response[:content_length] = data.size
		response[:data] = data
	else
		response[:status_code] = 404	
		response[:status_message] = "Not Found"
	end

	return response
end

def form_submittal_letter(params)
	response = Response.new

	template_letter = File.read("thanks.html") 
	erb_template = ERB.new template_letter

	# create method on LayoutRenderer. We'll pass a block to THIS method
	erb_template.def_method(LayoutRenderer, 'render')

	# Then call our LayoutRenderer
	result = LayoutRenderer.new.render do
  		"<li>Name: #{params["viking"]["name"]}</li><li>Email: #{params["viking"]["email"]}</li>"
	end

	response[:content_length] = result.size
	response[:data] = result

	return response
end

loop { 										# Servers run forever
	client = server.accept 	

	request = []
	while line = client.gets
		request << line
		break if line =~ /^\s*$/
	end
	request = parse_request(request.join)

	unless request.content_length.nil?
		body = []
		request.content_length.to_i.times do
			char = client.getc.chomp
			body << char
		end
		params = JSON.parse(body.join)
	end

	case request.command
	when "GET" then response = return_resource(request.path)
	when "POST" then response = form_submittal_letter(params)
	when "DELETE" then puts 'DELETE'
	when "HEAD" then puts 'HEAD'
	else puts "I do not know that command."
	end

	client.puts response.status_code.to_s + " " + response.status_message unless response.status_code.nil?
	client.puts Time.now.ctime				# Send the time to the client
	client.puts "Content Length: " + response.content_length.to_s + "\r\n\r\n" unless response.content_length.nil?
	client.puts response.data
	client.puts "Closing the connection. Bye!"
	client.close 				# Disconnect from the client
}
