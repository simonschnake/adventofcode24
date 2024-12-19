# Read the real input from a file and store it as a string
real_input = read("inputs/day19", String)

# Example test input for debugging and testing
test_input = "r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb"

# Function to parse the input into towel patterns and design requests
function parse_input(input)
    # Split the input into lines and remove any empty lines
    lines = split(input, "\n") |> filter(!isempty)
    # First line contains towel patterns, split by ", "
    towels = split(first(lines), ", ")
    # Sort towel patterns by length in descending order (helps matching)
    sort!(towels, by=length, rev=true)
    # Remaining lines are design patterns
    designs = lines[2:end]
    return towels, designs
end

# Cache dictionary for storing results of has_match to avoid recomputation
CACHE1 = Dict{String, Bool}()

# Function to check if a design can be formed using the given towels
function has_match(design, towels)
    # Return cached result if available
    if haskey(CACHE1, design)
        return CACHE1[design]
    end
    # If the design is empty, it's a match (base case)
    if isempty(design)
        return true
    end
    # Variable to store whether a match is found
    ans = false
    # Iterate through each towel pattern
    for towel in towels
        # Check if the design starts with the towel and recursively check the remainder
        if startswith(design, towel) && has_match(design[length(towel)+1:end], towels)
            ans = true
        end
    end
    # Cache the result for the design
    CACHE1[design] = ans
    return ans
end

# Cache dictionary for storing results of num_matches to avoid recomputation
CACHE2 = Dict{String, Int}()

# Function to calculate the number of ways a design can be formed using the towels
function num_matches(design, towels)
    # Return cached result if available
    if haskey(CACHE2, design)
        return CACHE2[design]
    end
    # If the design is empty, there is exactly one way to form it (base case)
    if isempty(design)
        return 1
    end
    # Variable to store the total number of ways to form the design
    ans = 0
    # Iterate through each towel pattern
    for towel in towels
        # If the design starts with the towel, recursively calculate for the remainder
        if startswith(design, towel)
            ans += num_matches(design[length(towel)+1:end], towels)
        end
    end
    # Cache the result for the design
    CACHE2[design] = ans
    return ans
end

# Main function to solve the problem
function main(input)
    # Parse the input into towel patterns and design requests
    towels, designs = parse_input(input)
    # Part 1: Count the number of designs that can be matched
    part1 = [has_match(design, towels) for design in designs] |> sum
    # Part 2: Count the total number of ways all designs can be formed
    part2 = [num_matches(design, towels) for design in designs] |> sum
    # Print the results
    println("Part 1: $part1")
    println("Part 2: $part2")
end

# Execute the main function with the real input
main(real_input)