
class TicTacToe
	attr_reader :current_player

	Player = Struct.new(:name, :mark)

	def initialize(player_name1, player_name2)
		@player1 = Player.new(player_name1, "x")
		@player2 = Player.new(player_name2, "o")
		@board_spaces = Array.new(9) 
		@game_over = false
		@victory = false
		@current_player = nil
		update_board(@board_spaces)
	end

	def game_over?
		@victory || @board_spaces.none? { |space| space.nil? }
	end

	def victory?
		@victory
	end

	def start_turn
		@current_player = (@current_player == @player1) ? @player2 : @player1
		print_current_player
	end

	def mark_board(board_space)
		if board_space.between?(1,9) && @board_spaces[board_space-1] == nil
			@board_spaces[board_space-1] = current_player.mark
			update_board(@board_spaces)
			check_for_victory(@rows, @cols, @diags)
			display_board(@board_spaces)
			return true
		else
			return false
		end
	end	

	private
	def print_current_player
		print "#{@current_player.name}'s turn (choose a space between 1 and 9): "
	end

	def update_board(board_spaces)
 		@rows = [
 		 		[board_spaces[0], board_spaces[1], board_spaces[2]],
 		 		[board_spaces[3], board_spaces[4], board_spaces[5]],
 		 		[board_spaces[6], board_spaces[7], board_spaces[8]]
 		]

 		@cols = [
 		 		[board_spaces[0], board_spaces[3], board_spaces[6]],
 		 		[board_spaces[1], board_spaces[4], board_spaces[7]],
 		 		[board_spaces[2], board_spaces[5], board_spaces[8]]
 		]

 		@diags = [
 		 		[board_spaces[0], board_spaces[4], board_spaces[8]],
 		 		[board_spaces[2], board_spaces[4], board_spaces[6]],
 		]
 	
	end

	def check_for_victory(rows, cols, diags)
		row_victory = rows.any? { |row| row.uniq.length == 1 && row[0] != nil }
		col_victory = cols.any? { |col| col.uniq.length == 1 && col[0] != nil }	
		diag_victory = diags.any? { |diag| diag.uniq.length == 1 && diag[0] != nil }
		
		@victory = true if (row_victory || col_victory || diag_victory) 
	end

	def display_board(board_spaces)
		puts "_#{board_spaces[0]}_|_#{board_spaces[1]}_|_#{board_spaces[2]}_"
		puts "_#{board_spaces[3]}_|_#{board_spaces[4]}_|_#{board_spaces[5]}_"
		puts " #{board_spaces[6]} | #{board_spaces[7]} | #{board_spaces[8]} "
	end
end

print "Enter Player 1's name: "
name1 = gets.chomp
print "Enter Player 2's name: "
name2 = gets.chomp

puts "Starting Game..."
game = TicTacToe.new(name1,name2)

until game.game_over?
	game.start_turn

	board_space = gets.chomp.strip.to_i
	valid_choice = game.mark_board(board_space)
	until valid_choice
		print "Invalid. Choose another space: "
		board_space = gets.chomp.strip.to_i
		valid_choice = game.mark_board(board_space)
	end
end

if game.victory?
	puts game.current_player.name + " WON!"
else
	puts "Draw"
end
