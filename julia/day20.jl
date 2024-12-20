using DataStructures

# Read the input file as a string
input = read("inputs/day20", String)

# Constants representing movement directions
const UP, RIGHT, DOWN, LEFT = CartesianIndex(0, -1), CartesianIndex(1, 0), CartesianIndex(0, 1), CartesianIndex(-1, 0)

# Function to parse the input map and initialize the grid, start, and end positions
function parse_input(input)
    # Split the input into lines and filter out empty lines
    lines = split(input, "\n") |> filter(!isempty)
    
    # Determine the number of rows and columns in the grid
    ncols = length(lines[1])
    nrows = length(lines)

    # Initialize a grid with boolean values (false = wall, true = track)
    grid = zeros(Bool, nrows, ncols)
    # Set default start and end positions
    start_pos, end_pos = CartesianIndex(1, 1), CartesianIndex(nrows, ncols)

    # Loop through each character in the input to populate the grid
    for (i, line) in enumerate(lines)
        for (j, c) in enumerate(line)
            if c == '#'
                grid[j, i] = false  # Wall
            elseif c == '.'
                grid[j, i] = true   # Track
            elseif c == 'S'
                grid[j, i] = true   # Start position
                start_pos = CartesianIndex(j, i)
            elseif c == 'E'
                grid[j, i] = true   # End position
                end_pos = CartesianIndex(j, i)
            end
        end
    end

    # Return the grid, start, and end positions
    return grid, start_pos, end_pos
end

# Function to calculate distances from the end position to all reachable positions
function distances(grid, start_pos, end_pos)
    # Dictionary to store distances to the end position
    dist = Dict{CartesianIndex{2}, Int}()
    # Priority queue for efficient processing of positions
    pq = MutableBinaryMinHeap{Tuple{Int, CartesianIndex{2}}}()

    # Initialize the distance of the end position to itself as 0
    dist[end_pos] = 0
    push!(pq, (0, end_pos))  # Push the end position to the priority queue

    # While there are positions to process
    while !isempty(pq)
        # Get the position with the lowest cost
        cur_cost, cur_pos = pop!(pq)

        # Skip processing if a shorter distance was already found
        if dist[cur_pos] < cur_cost
            continue
        end

        # Explore neighboring positions
        for dir in [UP, RIGHT, DOWN, LEFT]
            npos = cur_pos + dir  # Compute the neighbor position
            # Check if the neighbor is the start position
            if npos == start_pos
                dist[start_pos] = cur_cost + 1
                break
            end
            # Skip if out of bounds or not a valid track
            checkbounds(Bool, grid, npos) || continue
            grid[npos] || continue
            # Update distance if a shorter path is found
            if get(dist, npos, Inf) > cur_cost + 1
                dist[npos] = cur_cost + 1
                push!(pq, (cur_cost + 1, npos))
            end
        end
    end

    # Return the distance map
    return dist
end

# Function to calculate the Manhattan distance between two positions
function manhatten_distance(pos1::CartesianIndex{2}, pos2::CartesianIndex{2})
    x1, y1 = pos1.I
    x2, y2 = pos2.I
    return abs(x1 - x2) + abs(y1 - y2)
end

# Function to calculate the "cheat gain" for a given maximum cheat distance
function cheat_gain(dist, max_dist)
    cheat_dist = []  # List to store the cheat gains

    # Compare all pairs of positions to calculate gains
    for (pos, value) in dist
        for (npos, nvalue) in dist
            d = manhatten_distance(pos, npos)  # Distance between positions
            if d > max_dist
                continue  # Skip if the cheat exceeds the maximum distance
            end
            if pos == npos
                continue  # Skip if the positions are the same
            end
            # If a cheat results in a shorter path, calculate the gain
            if nvalue + d < value
                push!(cheat_dist, value - nvalue - d)
            end
        end
    end

    # Return the list of cheat gains
    return cheat_dist
end

# Main function to execute the solution
function main(input)
    # Parse the input to get the grid, start, and end positions
    grid, start_pos, end_pos = parse_input(input)
    # Calculate distances from the end position
    dist = distances(grid, start_pos, end_pos)
    
    # Part 1: Cheats with a maximum distance of 2
    max_dist_part1 = 2
    cheat_dist = cheat_gain(dist, max_dist_part1)
    cheats_better_100_part1 = sum(cheat_dist .≥ 100)
    println("Part 1: $cheats_better_100_part1")

    # Part 2: Cheats with a maximum distance of 20
    max_dist_part2 = 20
    cheat_dist = cheat_gain(dist, max_dist_part2)
    cheats_better_100_part2 = sum(cheat_dist .≥ 100)
    println("Part 2: $cheats_better_100_part2")
end

# Execute the main function with the input
main(input)