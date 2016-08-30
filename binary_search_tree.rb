class Node
	attr_accessor :parent
	attr_reader :l_child, :r_child, :value

	def initialize(value, parent = nil, r_child = nil, l_child = nil)
		@value = value
		@parent = parent
		@l_child = l_child
		@r_child = r_child	
	end

	def l_child=(l_node)
		@l_child = l_node
		@l_child.parent = self
	end

	def r_child=(r_node)
		@r_child = r_node
		@r_child.parent = self
	end
end

class BinaryTree
	attr_reader :root

	def initialize(values)
		@root = build_tree_with_unsorted(values)
	end

	def build_tree_with_sorted(sorted_values)
		return Node.new(sorted_values[0]) if sorted_values.size <= 1

		node = Node.new(sorted_values[sorted_values.length/2])
		node.l_child = build_tree(sorted_values[0..(sorted_values.length/2 - 1)])
		node.r_child = build_tree(sorted_values[(sorted_values.length/2+1)..-1])

		return node
	end

	def build_tree_with_unsorted(values)
		root = nil	

		values.each do |value|
			if root.nil?
				root = Node.new(value)
				next
			end
			add_node(root, value)
		end

		return root
	end

	def add_node(parent_node, value)
		if value < parent_node.value

			if parent_node.l_child.nil?
				parent_node.l_child = Node.new(value)
			else
				add_node(parent_node.l_child, value)
			end

		elsif value > parent_node.value

			if parent_node.r_child.nil?
				parent_node.r_child = Node.new(value)
			else
				add_node(parent_node.r_child, value)
			end

		else
			# Duplicate value, do nothing
		end

		puts "#{parent_node.value} R: #{parent_node.r_child ? parent_node.r_child.value : "nil"} L: #{parent_node.l_child ? parent_node.l_child.value : "nil"}"
	end

	def breadth_first_search(target_value)
		queue = [@root]

		until queue.empty?
			node = queue.slice!(0)
			return node if node.value == target_value
			queue << node.l_child unless node.l_child.nil?
			queue << node.r_child unless node.r_child.nil?
		end

		return nil
	end

	def depth_first_search(target_value)
		stack = []
		node = @root

		populate_stack_down_left(node, stack)

    until stack.empty?
			node = stack.pop
			puts "Popped #{node.value}"

			if node.value == target_value
				return node
			else
				node = node.r_child
			end

			populate_stack_down_left(node, stack)
		end

		return nil
	end

	def populate_stack_down_left(node, stack)
		until node.nil?
			stack.push(node)
			puts "pushed #{node.value}"
			node = node.l_child
		end
	end

	def dfs_rec(target_value, current_node = @root)
		dfs_rec(target_value, current_node.l_child) unless current_node.l_child.nil?
		puts current_node.value
		return current_node if current_node.value == target_value
		dfs_rec(target_value, current_node.r_child) unless current_node.r_child.nil?
	end
end

tree = BinaryTree.new([1, 7, 4, 23, 8, 9, 45])
p tree.breadth_first_search(23)
p tree.depth_first_search(23)
p tree.dfs_rec(56)
