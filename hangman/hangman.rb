class Game
	def self.play_again?
		print "Play again? (y/n): "
		continue = gets.chomp
		case continue
		when 'y' then puts "Starting a new game..."; return true
		when 'n' then puts "Quitting program"; return false
		else puts "Invalid entry. Quitting program."; return false
		end
	end
end

class Hangman < Game
	attr_reader :secret_word, :strikes_left, :wrong_guesses, :guess_progress

	def initialize
		@secret_word = get_word
		@strikes_left = 6
		@wrong_guesses = []
		@guess_progress = Array.new(@secret_word.length, '_')
		@game_over = false
		@victory = false
		welcome
	end

	def run
		until game_over? do
			display_game_status		
			get_input
		end
		puts (victory? ? "\nYou won!!" : "\nGame Over.") + " The secret word was #{@secret_word}"
	end

	private 

	def game_over?
		return @strikes_left == 0 || victory?
	end

	def victory?
		return @guess_progress.join == @secret_word
	end

	def welcome
		puts "Would you like to start a new game or load a saved game? (new/load) "
		game_options(gets.chomp.downcase)
	end

	def game_options(choice)
		case choice
		when 'new' then puts "Starting new game..."
		when 'load' then load_game
		else puts "Invalid entry. Starting new game..."
		end				
	end

	def load_game
		load_file = File.open("saved_games/hangman.marshal", "r").read
    	load_game = Marshal::load(load_file)
    	@secret_word = load_game.secret_word
		@strikes_left = load_game.strikes_left
		@wrong_guesses = load_game.wrong_guesses
		@guess_progress = load_game.guess_progress
	end

	def save_game_and_exit
		Dir.mkdir("saved_games") unless Dir.exists? "saved_games"
	    save_file = File.new("saved_games/hangman.marshal", "w")
	    save = Marshal::dump(self)
	    save_file.write(save)
	    save_file.close
	    puts "Game saved."
	    exit
	end

	def get_word
		words = get_words("5desk.txt")
		return words[ rand(words.length) ].chomp
	end

	def get_words(filename)
		words = File.open(filename).readlines
		words.select { |word| word.length.between?(5,12) }
	end

	def display_game_status
		puts
		puts @guess_progress.join(' ')
		print "Wrong guesses: #{@wrong_guesses.join(',')}"
		puts " (#{@strikes_left} strikes left)"
	end

	def get_input
		print "Enter letter guess or 'save' to save game: "
		user_input = gets.chomp.downcase
		parse_input(user_input)
	end

	def parse_input(user_input)
		if user_input == 'save'
			save_game_and_exit
		elsif @secret_word.include?(user_input)
			update_guess_progress(user_input)
		elsif @wrong_guesses.include?(user_input)
			puts "You already guessed that. Try again."
			get_input
		else
			add_wrong_guess(user_input)
		end		
	end

	def update_guess_progress(letter)
		i = 0
		@secret_word.each_char do |ch|
			@guess_progress[i] = ch if ch == letter
			i += 1
		end
	end

	def add_wrong_guess(letter)
		@strikes_left -= 1
		@wrong_guesses << letter
	end
end

puts "\nStarting Hangman"

loop do 
	game = Hangman.new
	game.run
	exit unless Game.play_again?		
end

