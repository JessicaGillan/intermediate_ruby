
class TicTacToe
	attr_reader :current_player

	Player = Struct.new(:name, :mark)

	def initialize
		@board_spaces = Array.new(3) { Array.new(3,"_") }
		@current_player = nil

		welcome
	end

	def play
		until game_over?
			start_turn

			row, col = get_valid_choice
			mark_board(row, col)			
			display_board(@board_spaces)
		end

		print_result
	end

	def self.play_again?
		print "Play again? (y/n): "
		continue = gets.chomp

		case continue
		when 'y' 
			puts "Starting a new game..."
			return true
		when 'n' then puts "Quitting program"
		else puts "Invalid entry. Quitting program."
		end

		return false
	end

	private

	def game_over?
		victory? || @board_spaces.none? { |space| space == "_" }
	end

	def get_valid_choice
		board_space = gets.chomp
		row, col = board_space.split(" ")
		until row.between?(1,3) && col.between?(1,3) && @board_spaces[row-1][col-1] == "_"
			print "Invalid. Choose another space: "
			board_space = gets.chomp.strip.to_i
			row, col = board_space.split(" ")
		end

		return row, col
	end

	def mark_board(row, col)
		@board_spaces[row-1] [col-1]= current_player.mark
		update_board(@board_spaces)
	end	

	def update_board(board_spaces)
		cols = []
		forwardDiag = []
		backwardDiag = []

		for j in (0..board_spaces.length-1) do
			# Process columns
			col = []
			for i in (0..board_spaces.length-1) do
				col << board_spaces[i][j]
			end
			cols << col

			# Process diagonals
			forwardDiag << board_spaces[j][j]
			backwardDiag << board_spaces[j][board_spaces.length-1-j]
		end

		@boardUnits = forwardDiag + backwardDiag + board_spaces + cols
	end

	def welcome
		print "Enter Player 1's name: "
		name1 = gets.chomp
		print "Enter Player 2's name: "
		name2 = gets.chomp

		set_players(name1, name2)

		puts "Starting Game..."
	end

	def set_players(player1,player2)
		@player1 = Player.new(player1, "x")
		@player2 = Player.new(player2, "o")
	end

	def start_turn
		@current_player = (@current_player == @player1) ? @player2 : @player1
		print_current_player
	end

	def print_current_player
		print "#{@current_player.name}'s turn (choose a space between 1 and 9): "
	end

	def print_result
		puts victory? ? @current_player.name + " WON!" : "Draw"
	end

	def victory?
		victory = @boardUnits.any? { |unit| unit.uniq.length == 1 && unit[0] != "_" }
		
		return victory ? true : false
	end

	def display_board(board_spaces)
		puts " ___________"

		for i in (0..2) do
				puts "|_#{board_spaces[i][0]}_|_#{board_spaces[i][1]}_|_#{board_spaces[i][2]}_|"
		end 

		puts ""
	end
end

loop do 	
	game = TicTacToe.new
	game.play	

	exit unless TicTacToe.play_again?
end



