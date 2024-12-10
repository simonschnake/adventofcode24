# Read the input data as a string
input = read("inputs/day10", String)

# Function to convert the input string into a 2D numerical field
function to_field(input)
    # Split the input into lines
    lines = split(input, "\n")
    # Remove empty lines
    filter!(x -> length(x) > 0, lines)
    # Convert each line into an array of integers and stack them horizontally
    field = hcat(map(lines) do line
        collect.(line)  # Collect characters from the line
    end...)
    parse.(Int, field)  # Parse characters into integers
end

# Function to find the starting positions (trailheads) in the field
function start_positions(field)
    # Find all positions where the value is 0 (trailheads)
    findall(x -> x == 0, field)
end

# Function to find the neighbors of a given position in the field
function neighbours(field, c)
    return [
        c + CartesianIndex(1, 0),  # Neighbor below
        c + CartesianIndex(-1, 0), # Neighbor above
        c + CartesianIndex(0, 1),  # Neighbor to the right
        c + CartesianIndex(0, -1)  # Neighbor to the left
    ]
end

# Function to find all valid hiking routes
function check_routes(field)
    # Initialize the queue with starting positions and their initial routes
    queue = [(c, 0, [c]) for c in start_positions(field)]

    # Set to store all unique hiking routes
    routes = Set{Vector{CartesianIndex{2}}}()

    # Process the queue until it's empty
    while !isempty(queue)
        # Dequeue the first element (current position, height, and route)
        (c, d, r) = popfirst!(queue)
        if field[c] == 9
            # If the position has height 9, it's the end of a route; add to routes
            push!(routes, r)
        else
            # Otherwise, check neighbors for valid continuations of the route
            for n in neighbours(field, c)
                # Check if the neighbor is within bounds and has the correct height
                if checkbounds(Bool, field, n) && field[n] == d + 1
                    # Add the neighbor to the queue with an updated route
                    push!(queue, (n, d + 1, [r; n]))
                end
            end
        end
    end

    return routes  # Return the set of unique routes
end

# Convert the input into a numerical field
field = to_field(input)

# Find all hiking routes starting from trailheads
routes = check_routes(field)

# Part 1: Calculate the number of unique (start, end) trailhead pairs
result_part1 = length(Set([(first(r), last(r)) for r in routes]))

# Part 2: Calculate the total number of distinct hiking trails
result_part2 = length(routes)

# Print the results for both parts
println("Part 1: $result_part1")
println("Part 2: $result_part2")