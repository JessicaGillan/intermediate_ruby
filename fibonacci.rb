def fibs(n)
	fibs = [0,1]
	if n < 3 then return fibs[0..n-1]
	else
		n1 = 0
		n2 = 1		
		(n-2).times do 
			temp = n2
		    n2 = n1 + n2
		    n1 = temp

		    fibs << n2
		end
	end
	return fibs
end

print fibs(12)
puts ""

def fibs_rec(n)
	return [0,1][0,n] if n < 3
	result = fibs_rec(n-1)
	result << (result[-2] + result[-1])
end

print fibs_rec(12)