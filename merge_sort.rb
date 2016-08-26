
def merge_sort(arr)	
	return arr if arr.length == 1 

	part1 = merge_sort(arr[0..arr.length/2-1])
	part2 = merge_sort(arr[arr.length/2..-1])

	sorted = []
	until part1[0].nil? || part2[0].nil?
			sorted << (part1[0] <= part2[0] ? part1.slice!(0) : part2.slice!(0))
	end

	sorted += (part1.empty? ? part2 : part1)

	return sorted
end

print merge_sort([3,6,4,8,34,32,0,3,46,8,56,9,87,4])