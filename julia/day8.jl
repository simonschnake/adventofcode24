# Read the input file containing the map of antennas
input = readlines("inputs/day8")

# Function to convert input into a 2D field
function to_field(input)
    # Convert each line of the input into a collection of characters and stack them horizontally
    field = hcat(map(input) do line
        collect.(line) # Collect characters from the line
    end...)
end

# Function to solve Day 8 problem
function solve_day8(field)
    # Get the dimensions of the field
    ncol, nrow = size(field)

    # Dictionary to store antenna positions for each frequency (character)
    antennas = Dict{Char, Vector{CartesianIndex{2}}}()

    # Populate the dictionary with the positions of antennas
    for i in 1:nrow, j in 1:ncol
        if field[i, j] != '.' # Check if the cell contains an antenna
            push!(
                get!(antennas, field[i, j], Vector{CartesianIndex{2}}()), # Add to frequency's positions
                CartesianIndex(i, j) # Store the position
            )
        end
    end

    # Initialize sets to store unique antinodes for Part 1 and Part 2
    antinode_part1 = Set{CartesianIndex{2}}()
    antinode_part2 = Set{CartesianIndex{2}}()

    # Iterate over each cell in the field
    for c in CartesianIndices(field)
        x, y = c.I # Get x and y coordinates of the current cell
        for (_, positions) in antennas # Iterate over antenna frequencies and their positions
            for i in 1:length(positions), j in 1:length(positions) # Check all pairs of antenna positions
                if positions[i] == positions[j]
                    continue # Skip if the positions are the same
                end
                # Get coordinates of the two antennas
                x1, y1 = positions[i].I
                x2, y2 = positions[j].I

                # Calculate Manhattan distances between antennas and current cell
                d1 = abs(x - x1) + abs(y - y1)
                d2 = abs(x - x2) + abs(y - y2)

                # Calculate direction vectors from the current cell to antennas
                dx1 = x - x1
                dx2 = x - x2
                dy1 = y - y1
                dy2 = y - y2

                # Part 1 condition: d1 is twice d2 (or vice versa) and directions are collinear
                if (d1 == 2 * d2 || d1 == d2 * 2) && (dx1 * dy2 == dx2 * dy1)
                    push!(antinode_part1, c) # Add to Part 1 antinodes
                end
                # Part 2 condition: directions are collinear
                if dx1 * dy2 == dx2 * dy1
                    push!(antinode_part2, c) # Add to Part 2 antinodes
                end
            end
        end
    end

    # Return sets of antinodes for Part 1 and Part 2
    antinode_part1, antinode_part2
end

# Convert the input into a field
field = to_field(input)

# Solve the problem and get the results for both parts
antinode_part1, antinode_part2 = solve_day8(field)

# Print the results
println("Part 1: ", length(antinode_part1)) # Number of unique Part 1 antinodes
println("Part 2: ", length(antinode_part2)) # Number of unique Part 2 antinodes