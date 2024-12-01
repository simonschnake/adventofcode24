# Read the input data from the file "inputs/day1", each line representing a pair of numbers separated by spaces.
input = readlines("inputs/day1")

# Parse the input data into a 2D array where each column represents a pair of numbers (left and right list entries).
x = hcat(map(input) do x
    x = split(x, "   ")
    x = parse.(Int, x) 
end...)

####### Part 1 #######

# Sort both rows of the array `x` to align numbers for minimum pairwise difference.
a = sort(x[1, :])                  # Sort the first row (left list).
b = sort(x[2, :])                  # Sort the second row (right list).

# Calculate the sum of the absolute differences between paired numbers in the sorted lists.
println("Result Part 1: ", sum(abs.(a .- b)))  # Print the result for Part 1.

####### Part 2 #######

# Create a dictionary to store the count of occurrences of each number in the right list for the left list.
d = Dict()

# Populate the dictionary: for each number in the left list, count its occurrences in the right list.
d[a] = map(a) do x
    count(y -> y == x, b)          # Count how many times the number `x` appears in the right list.
end

# Calculate the similarity score by summing each number in the left list multiplied by its count in the right list.
println("Result Part 2: ", sum(a .* d[a]))     # Print the result for Part 2.