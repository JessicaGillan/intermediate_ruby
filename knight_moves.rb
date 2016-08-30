# Your task is to build a function knight_moves that shows the simplest possible way 
# to get from one square to another by outputting all squares the knight will stop on 
# along the way.

class KnightSquare
	@@range = (0..7)

	attr_accessor :parent
	attr_reader :coords

	def initialize(coordinates)
		@coords = coordinates
		@row = coordinates[0]
		@col = coordinates[1]
		@parent = nil
	end

	def north_right_child
		@north_right_child ||= create_child(@row+2, @col+1)
	end

	def north_left_child
		@north_left_child ||= create_child(@row+2, @col-1)
	end

	def east_right_child
		@east_right_child ||= create_child(@row-1, @col+2) 
	end

	def east_left_child
		@east_left_child ||= create_child(@row+1, @col+2) 
	end

	def south_right_child
		@south_right_child ||= create_child(@row-2, @col-1) 
	end

	def south_left_child
		@south_left_child ||= create_child(@row-2, @col+1) 
	end

	def west_right_child
		@west_right_child ||= create_child(@row+1, @col-2) 
	end

	def west_left_child
		@west_left_child ||= create_child(@row-1, @col-2) 
	end

	private

	def create_child(row, col)
		if @@range.include?(row) && @@range.include?(col)
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
		queue << square.north_right_child unless square.north_right_child.nil?
		queue << square.north_left_child unless square.north_left_child.nil?
		queue << square.east_right_child unless square.east_right_child.nil?
		queue << square.east_left_child unless square.east_left_child.nil?
		queue << square.south_right_child unless square.south_right_child.nil?
		queue << square.south_left_child unless square.south_left_child.nil?
		queue << square.west_right_child unless square.west_right_child.nil?
		queue << square.west_left_child unless square.west_left_child.nil?
 	end

	return nil
end

def knight_moves(start_square, end_square)
	root = KnightSquare.new(start_square) 
 	square = breadth_first_search(root, end_square)
 	path = []
 	count = 0

 	until square == root
 		path = [square.coords] + path
 		square = square.parent
 		count += 1
 	end
 	path = [square.coords] + path 

 	puts "You made it in #{count} moves!  Here's your path:"
 	path.each do |coords|
 		p coords
 	end
end

knight_moves([3,3],[4,3])
# You made it in 3 moves!  Here's your path:
# [3, 3]
# [5, 4]
# [3, 5]
# [4, 3]
