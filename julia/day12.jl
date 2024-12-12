# Read the input file as a string
input = read("inputs/day12", String)

# Converts the input string into a 2D field of characters
function to_field(input)
    lines = split(input, '\n')  # Split the input into lines
    filter!(x -> x != "", lines)  # Remove empty lines
    hcat(map(lines) do line
        collect.(line)  # Convert each line into a collection of characters
    end...)
end

# Define directions as Cartesian indices for movement
const UP = CartesianIndex(0, -1)   # Move up
const DOWN = CartesianIndex(0, 1)  # Move down
const LEFT = CartesianIndex(-1, 0) # Move left
const RIGHT = CartesianIndex(1, 0) # Move right

# Array of all possible directions
const DIRS = [UP, DOWN, LEFT, RIGHT]

# Calculates the total price of fences for the garden map
function calc(field)
    seen = Set{CartesianIndex{2}}()  # Tracks already-visited positions
    ans1 = 0  # Total cost for Part 1
    ans2 = 0  # Total cost for Part 2

    # Iterate over all positions in the field
    for pos in CartesianIndices(field)
        if pos in seen
            continue  # Skip already-visited positions
        end

        c = field[pos]  # Get the plant type at the current position
        area = Set([pos])  # Set to track the current region's positions
        n_perim = 0  # Initialize the perimeter counter
        perim = Set()  # Tracks edges of the region
        queue = [pos]  # Queue for breadth-first search (BFS)

        # BFS to explore the region
        while length(queue) > 0
            pos = pop!(queue)  # Dequeue a position
            for dir in DIRS  # Check all directions
                new_pos = pos .+ dir  # Calculate the new position
                if checkbounds(Bool, field, new_pos) && field[new_pos] == c  # In region
                    if new_pos in area
                        continue  # Skip if already in the region
                    end
                    push!(queue, new_pos)  # Add to queue
                    push!(area, new_pos)  # Mark as part of the region
                else
                    push!(perim, (new_pos, dir))  # Add edge to perimeter
                    n_perim += 1  # Increment perimeter count
                end
            end
        end

        sides = 0  # Initialize the number of sides for Part 2

        # Process the perimeter to count sides
        while length(perim) > 0
            pos, dir = pop!(perim)  # Get an edge
            sides += 1  # Increment the side count
            queue = [pos]  # Queue for BFS along edges
            while length(queue) > 0
                pos = pop!(queue)  # Dequeue a position
                new_pos = pos .+ DIRS  # Calculate neighboring edges
                filter!(x -> (x, dir) in perim, new_pos)  # Keep valid edges
                for p in new_pos
                    push!(queue, p)  # Add to queue
                    delete!(perim, (p, dir))  # Remove from perimeter
                end
            end
        end

        # Update the global results
        union!(seen, area)  # Mark the region as seen
        n_area = length(area)  # Calculate the area of the region
        ans1 += n_area * n_perim  # Add to Part 1 total
        ans2 += n_area * sides  # Add to Part 2 total
    end
    ans1, ans2  # Return both results
end

# Convert the input into a 2D field
field = to_field(input)

# Calculate the results for both parts
part1, part2 = calc(field)

# Print the results
println("Part 1: $part1")
println("Part 2: $part2")