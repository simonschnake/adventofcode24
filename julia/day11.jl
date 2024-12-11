# Read the input file as a string
input = read("inputs/day11", String)

# Function to calculate the number of digits in an integer
function number_of_digits(n::Integer)
    count = 0
    x = float(n)  # Convert the integer to a float
    while x >= 1  # Loop until the number is less than 1
        x /= 10   # Divide the number by 10
        count += 1  # Increment the digit count
    end
    return count  # Return the total digit count
end

# Function to split a number into two parts based on its digits
function split_stone(n, num_digits)
    # Divide the number into left and right halves
    n ÷ 10^(num_digits ÷ 2), n % 10^(num_digits ÷ 2)
end

# Function to process a dictionary of stones based on the blinking rules
function blink(nums::Dict{Int, Int})
    new_nums = Dict{Int, Int}()  # Initialize a new dictionary for the updated stones
    for (k, v) in nums
        num_digits = number_of_digits(k)  # Count the digits in the current stone key
        if k == 0
            # If the stone is 0, replace it with a stone marked 1
            new_nums[1] = get(new_nums, 1, 0) + v
        elseif num_digits % 2 == 0
            # If the number has an even number of digits, split it into two stones
            a, b = split_stone(k, num_digits)
            new_nums[a] = get(new_nums, a, 0) + v
            new_nums[b] = get(new_nums, b, 0) + v
        else
            # Otherwise, replace the stone with a new stone marked k * 2024
            new_nums[k * 2024] = get(new_nums, k * 2024, 0) + v
        end
    end

    return new_nums  # Return the updated dictionary
end


function solve(input)

    # Parse the input string into integers
    stones = split(input, " ") .|> x -> parse(Int, x)

    # Convert the stones into a dictionary with initial counts of 1
    stones = Dict([s => 1 for s in stones]) 

    # Initialize variables to store the results for part 1 and part 2
    part1_solution = 0
    part2_solution = 0

    # Apply the blinking rules for 75 iterations
    for i in 1:75
        stones = blink(stones)
        if i == 25
            part1_solution = sum(values(stones))  # Record the number of stones after 25 blinks
        end
        if i == 75
            part2_solution = sum(values(stones)) # Record the number of stones after 75 blinks
        end
    end

    return part1_solution, part2_solution  # Return the solutions for both parts
end

# Call the solve function with the input data
part1_solution, part2_solution = solve(input)

# Print the solutions to both parts
println("Part 1: Number of stones after 25 blinks = $part1_solution")
println("Part 2: Number of stones after 75 blinks = $part2_solution")