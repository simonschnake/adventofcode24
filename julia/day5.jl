# Read input lines from the file "inputs/day5"
input = readlines("inputs/day5")

# For testing purposes, here's the test input (commented out in actual use)
test_input = split("47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47", '\n')

# Function to parse the input into rules and number sequences
function parse_input(input)
    # Find the index of the empty line that separates rules from number sequences
    split_line_idx = findfirst(x -> x == "", input)

    # Extract rule lines from the input
    rule_lines = input[1:split_line_idx-1]

    # Initialize a dictionary to store the rules
    # Key: page number; Value: vector of page numbers that must come after the key
    rules = Dict{Int, Vector{Int}}()

    # Parse each rule line and populate the rules dictionary
    for line in rule_lines
        # Split the rule into two page numbers
        first_str, second_str = split(line, "|")
        first_numb = parse(Int, first_str)
        second_numb = parse(Int, second_str)
        # If the first page number already has an entry, append the second number
        if haskey(rules, first_numb)
            push!(rules[first_numb], second_numb)
        else
            # Otherwise, create a new entry with the second number
            rules[first_numb] = [second_numb]
        end
    end 

    # Extract number sequences from the input
    number_lines = map(input[split_line_idx+1:end]) do line
        # Split each line by commas and parse the page numbers into integers
        parse.(Int, split(line, ","))
    end

    # Return the parsed rules and the list of number sequences
    return rules, number_lines
end

# Function to evaluate sequences and calculate the results
function exercise(rules, number_lines)
    # Initialize result variables
    res1 = 0  # Sum of middle page numbers from initially correct sequences
    res2 = 0  # Sum of middle page numbers from corrected sequences

    # Iterate over each sequence of page numbers
    for numbers in number_lines
        correct_order = false          # Flag to determine if the sequence is in correct order
        initial_correct_order = true   # Flag to check if the sequence was initially correct

        # Keep rearranging the sequence until it is in correct order
        while !correct_order
            correct_order = true  # Assume the sequence is correct to start
            for (i1, num1) in enumerate(numbers)
                if i1 == 1
                    # Skip the first number as there's nothing before it
                    continue
                end
                if !haskey(rules, num1)
                    # If there are no rules for this number, continue
                    continue
                end
                # Get the list of numbers that should come before num1
                nums = rules[num1]
                # Check all previous numbers in the sequence
                for (i2, num2) in enumerate(numbers[1:i1-1])
                    if num2 in nums
                        # If num2 should come after num1 according to the rules, swap them
                        correct_order = false          # The sequence is not in correct order
                        initial_correct_order = false  # The sequence was not initially correct
                        numbers[i1], numbers[i2] = numbers[i2], numbers[i1]  # Swap the numbers
                        break  # Break to re-evaluate the sequence after swapping
                    end
                end
            end
        end

        # After ensuring the sequence is in correct order, add the middle page number to the result
        middle_index = length(numbers) ÷ 2 + 1  # Calculate the middle index
        if initial_correct_order
            res1 += numbers[middle_index]  # Add to res1 if the sequence was initially correct
        else
            res2 += numbers[middle_index]  # Add to res2 if the sequence was corrected
        end
    end

    # Return the calculated results
    return res1, res2
end

# Parse the input to get the rules and number sequences
rules, number_lines = parse_input(input)

# Evaluate the sequences and obtain the results
result_1, result_2 = exercise(rules, number_lines)

# Print the results for both parts
println("Result part 1: ", result_1)
println("Result part 2: ", result_2)