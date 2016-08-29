class Node

	def initialize(value = nil, next_node = nil)
		@value = value
		@next_node = next_node		
	end

	def value
		@value
	end

	def next_node
		@next_node
	end

	def next_node=(node)
		@next_node = node
	end
end

class LinkedList
	def initialize
		@size = 0
		@last_node = nil
		@first_node = nil
	end

	def size
		@size
	end

	def append(node_data)
		node = Node.new(node_data)
		if @last_node == nil
			@last_node = node
			@first_node = node
		else
			@last_node.next_node = node 
			@last_node = node
		end
		@size += 1
	end

	def prepend(node_data)
		node = Node.new(node_data)
		if @first_node == nil
			@last_node = node
			@first_node = node
		else
			node.next_node = @first_node
			@first_node = node
		end
		@size += 1
	end

	def head
		@first_node
	end

	def tail
		@last_node
	end

	def at(index)
		node = @first_node
		index.times do 
			node = node.next_node
		end
		return node
	end

	def pop
		node_to_return = @last_node
		node = @first_node

		(@size-2).times do # -1 to get to account for starting at 0, -1 to go to second to last node
			node = node.next_node
		end

		node.next_node = nil
		@last_node = node
		@size -= 1

		return node_to_return
	end

	def contains?(value)
		node = @first_node
		until node == nil
			if node.value == value
				return true
			end
			node = node.next_node
		end
		return false		
	end

	def find(data)
		node = @first_node
		index = 0
		until node == nil
			if node.value == data
				return index
			end
			node = node.next_node
			index += 1
		end
		return nil
	end

	def to_s
		s = ""
		node = @first_node
		@size.times do
			s += "( #{node.value} ) -> " 
			node = node.next_node
		end
		s += "nil"
	end
end

list = LinkedList.new

list.append(1)
puts list
list.append(2)
puts list
list.append(3)
puts list

p list.pop
puts list

p list.contains? 1
p list.contains? 7
p list.find(1)
p list.find(34)

