require 'jumpstart_auth'
require 'bitly'

Bitly.use_api_version_3

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing MicroBlogger"
		@client = JumpstartAuth.twitter
		@bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
	end	

	def tweet(message)
		if message.length <= 140 
			@client.update(message) 
		else 
			puts "Message too long! (140 characters max)"
		end
	end

	def dm(target, message)
		if followers_list.include? target.downcase
			puts "Trying to send #{target} this direct message"
			puts message
			message = "d @#{target} #{message}"
			tweet(message)
		else
			puts "Error. Cannot DM a user who doesn't follow you."
		end
	end

	def followers_list
		screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name.downcase }
		return screen_names
	end

	def spam_my_followers(message)
		followers_list.each { |follower| dm(follower, message) }
	end

	def everyones_last_tweet
		friends = @client.followers.sort_by { |friend| @client.user(friend).screen_name.downcase }
		friends.each do |friend|
			last_message = @client.user(friend).status
			timestamp = last_message.created_at
			time = timestamp.strftime("%A, %b %d")
			puts "#{last_message.user.screen_name} said this on #{time}"
			puts last_message.text
			puts "" # Separator line
		end
	end

	def shorten(original_url)
		puts "Shortening this URL: #{original_url}"
		return @bitly.shorten(original_url).short_url
	end

	def run
		puts "Welcome to the JSL Twitter Client!"
		command = ""
		while command != "q"
			print "Enter command: "
			input = gets.chomp
			parts = input.split
			command = parts[0]
			case command
			when 'q' then puts "Goodbye!"
			when 't' then tweet(parts[1..-1].join)		
			when 'dm' then dm(parts[1], parts[2..-1].join)	
			when 'spam' then spam_my_followers(parts[1..-1].join)
			when 'elt' then everyones_last_tweet
			when 's' then shorten(parts[1..-1])		
			when 'turl' then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
			else
				puts "Sorry, I don't know how to #{command}"
			end
		end
	end
end

blogger = MicroBlogger.new
blogger.run