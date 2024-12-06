# Load input and prepare the simulation field
input = readlines("inputs/day6")  # Read the input map from the file
field = hcat(collect.(input)...)  # Convert each line into characters and stack them into a 2D array

# Define movement directions as Cartesian indices
const DIRS = [
    CartesianIndex(0, -1), # up
    CartesianIndex(1, 0),  # right
    CartesianIndex(0, 1),  # down
    CartesianIndex(-1, 0)  # left
]

# Find the guard's starting position and initial direction
const start_pos = findfirst(x -> x == '^', field)  # Locate the guard's starting position (^)
const start_dir = 1  # The guard starts facing "up" (index 1 in DIRS)

# Simulate the guard's patrol
function simulate(field)
    visited_pos = Set{CartesianIndex{2}}()         # Set to track all visited positions
    visited_states = Set{Tuple{CartesianIndex{2}, Int}}()  # Track visited states (position + direction)

    pos = start_pos  # Current position of the guard
    dir = start_dir  # Current direction of the guard

    push!(visited_pos, pos)  # Add starting position to visited positions
    push!(visited_states, (pos, dir))  # Add starting state (position + direction)

    while true
        # Compute the next position the guard will attempt to move to
        peak = pos + DIRS[dir]

        # Check if the guard is out of bounds; if so, return visited positions and exit the simulation
        if !checkbounds(Bool, field, peak)
            return visited_pos, false
        end

        # If the next position is an obstacle, turn right (change direction)
        if field[peak] == '#'
            dir = mod1(dir + 1, 4)  # mod1 ensures direction wraps around (1 to 4)
        else
            # If the path is clear, move to the next position and record it
            pos = peak
            push!(visited_pos, pos)
        end

        # Check if the guard has entered a repeated state (loop detection)
        state = (pos, dir)
        if state in visited_states
            return visited_pos, true  # Return visited positions and indicate a loop was detected
        end
        push!(visited_states, state)  # Record the current state

        # Check bounds again after moving (safety check)
        if !checkbounds(Bool, field, pos)
            return visited_pos, false
        end
    end
end

# Part 1: Count the number of unique positions visited by the guard
function part1(field)
    visited_pos, loop_detected = simulate(field)  # Simulate the guard's movements
    println("Part 1: ", length(visited_pos))  # Print the number of distinct visited positions
end

# Part 2: Find possible positions to place an obstruction to cause a loop
function part2(field)
    positions, _ = simulate(field)  # Simulate the guard's initial movements
    possible_pos = filter(x -> x != start_pos, positions)  # Exclude the starting position
    possible_pos = collect(possible_pos)  # Convert to a collection for iteration

    # Check each candidate position by temporarily placing an obstruction and simulating
    res = map(possible_pos) do pos
        new_field = deepcopy(field)  # Create a copy of the field
        new_field[pos] = '#'  # Place an obstruction at the candidate position
        visited_pos, loop_detected = simulate(new_field)  # Simulate with the obstruction
        loop_detected  # Return whether a loop was detected
    end |> sum  # Count the positions that caused loops

    println("Part 2: ", res)  # Print the number of loop-causing positions
end

# Execute both parts of the puzzle
part1(field)  # Solve Part 1
part2(field)  # Solve Part 2