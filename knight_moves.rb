# Your task is to build a function knight_moves that shows the simplest possible way 
# to get from one square to another by outputting all squares the knight will stop on 
# along the way.

class KnightSquare
	$range = (0..7)
	$moves = [ [2,1], [2,-1], [-1,2], [1,2], [-2,1], [-2,-1], [1,-2], [-1,-2] ]

	attr_accessor :parent
	attr_reader :coords

	def initialize(coordinates)
		@coords = coordinates
		@row = coordinates[0]
		@col = coordinates[1]
		@parent = nil
	end

	def possible_destinations 
		if @possible_destinations.nil?
			@possible_destinations = Hash.new { |hash, key| hash[key] = create_child(@row+key[0], @col+key[1]) }

			$moves.each do |move|
				@possible_destinations[move]
			end
		end

		return @possible_destinations
	end

	private

	def create_child(row, col)
		if $range.include?(row) && $range.include?(col)

			child = KnightSquare.new([row, col])
			child.parent = self
			return child
			
		else
			return nil
		end		
	end
end

def breadth_first_search(root, end_square)
 	queue = [root]

	until queue.empty?
 		square = queue.slice!(0)

		return square if square.coords == end_square

		square.possible_destinations.each do |_,square|
			queue << square unless square.nil?
		end
 	end

	return nil
end

def print_path(path, count)
 	puts "You made it in #{count} moves!  Here's your path:" 

 	until path.empty?
 		print path.pop.to_s + " "
 	end 	
 	puts
end

def get_path(root, end_square)
	path = []
 	count = 0

 	until end_square == root
 		path.push(end_square.coords)
 		end_square = end_square.parent
 		count += 1
 	end
 	path.push(end_square.coords)

 	print_path(path, count)
end

def knight_moves(start_coords, end_coords)
	root = KnightSquare.new(start_coords) 
 	end_square = breadth_first_search(root, end_coords)
 	get_path(root, end_square)
end

# testing
knight_moves([3,3],[4,3])
# You made it in 3 moves!  Here's your path:
# [3, 3] [5, 4] [3, 5] [4, 3] 

knight_moves([0,0],[1,2]) # => [0, 0] [1, 2] 
knight_moves([0,0],[3,3]) #=> [0, 0] [2, 1] [3, 3]
knight_moves([3,3],[0,0]) # => [3, 3] [1, 2] [0, 0] 
knight_moves([6,7], [3,5]) # => [6, 7] [4, 6] [2, 7] [3, 5] 

