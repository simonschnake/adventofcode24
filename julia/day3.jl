# Read the puzzle input as a string
input = read("inputs/day3", String)

# Define a regular expression to match the valid `mul(X, Y)` instructions
pattern = r"mul\(\s*(\d+)\s*,\s*(\d+)\s*\)"
# Extract all matches of the `mul` pattern from the input
matches = eachmatch(pattern, input)

# Part 1: Sum the results of all valid `mul` operations
# Map each match to the product of the captured numbers, convert to integers, and sum the results
result1 = map(matches) do m
    parse(Int, m.captures[1]) * parse(Int, m.captures[2])
end |> sum

# Print the result for Part 1
println("Result Part 1: ", result1)

# Part 2: Handle `do()` and `don't()` instructions for conditional execution
# Create a dictionary to hold instructions, keyed by their position in the input
instructions = Dict{Int, Tuple{String, Int64, Int64}}()

# Find all `do` instructions in the input and add them to the instructions dictionary
map(findall("do", input)) do m
    instructions[m |> first] = ("do", 0, 0)  # Store the instruction type and dummy arguments
end

# Find all `don't` instructions in the input and add them to the instructions dictionary
map(findall("don't", input)) do m
    instructions[m |> first] = ("don't", 0, 0)  # Store the instruction type and dummy arguments
end

# Add the valid `mul` instructions (already captured earlier) to the instructions dictionary
map(matches) do m
    instructions[m.offset |> first] = ("mul", parse(Int, m.captures[1]), parse(Int, m.captures[2]))
end

# Initialize state and result variables
activated = true  # Initially, all `mul` instructions are enabled
result2 = 0       # Accumulate the result for Part 2

# Iterate over the instructions in order of their positions in the input
for x in (keys(instructions) |> collect |> sort)
   instr = instructions[x]  # Get the instruction details at the current position
   s = instr[1]             # Extract the instruction type (e.g., "do", "don't", or "mul")
   if s == "do"
       activated = true  # Enable subsequent `mul` instructions
    elseif s == "don't"
        activated = false  # Disable subsequent `mul` instructions
    else
        # If the instruction is a `mul` and activation is enabled, add its result to the total
        if activated
            result2 += instr[2] * instr[3]
        end
    end
end

# Print the result for Part 2
println("Result Part 2: ", result2)