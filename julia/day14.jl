# Read the input file as a single string
input = read("inputs/day14", String)

# Function to parse the input into a list of robots
function parse_input(input)
    # Split the input into individual lines
    lines = split(input, '\n')
    # Remove any empty lines
    filter!(!isempty, lines)
    # Process each line into a robot's position and velocity
    map(lines) do line
        # Split the line into position and velocity components
        a, b = split(line, " v=")
        # Parse the position and velocity into integers
        p = split(a[3:end], ",") .|> x -> parse(Int, x)
        v = split(b, ",") .|> x -> parse(Int, x)
        # Convert the position to 1-indexed for Julia arrays
        p .+= 1
        # Return the position and velocity as a tuple
        p, v
    end
end

# Function to update the position of each robot based on its velocity
function step!(robots, field_size)
    for robot in robots
        # Update the position based on the velocity
        robot[1] .+= robot[2]
        # Handle wrap-around behavior using modular arithmetic
        robot[1][1] = mod1(robot[1][1], field_size[1]) # Wrap around horizontally
        robot[1][2] = mod1(robot[1][2], field_size[2]) # Wrap around vertically
    end
end

# Function to populate the field with robot positions
function fill_field(robots, field_size)
    # Initialize a field matrix with zeros
    field = zeros(Int, field_size...)
    for robot in robots
        # Increment the count for the tile at the robot's position
        pos = robot[1]
        field[pos[1], pos[2]] += 1
    end
    return field
end

# Part 1: Calculate the safety factor after 100 steps
function solve_part1(input)
    # Parse the input into robot positions and velocities
    robots = parse_input(input)
    # Generate the initial field with size (101 x 103)
    field = fill_field(robots, (101, 103))

    # Calculate the safety factor by summing counts in each quadrant
    result_1 = sum(field[1:50, 1:51]) * sum(field[52:end, 53:end]) * 
               sum(field[1:50, 53:end]) * sum(field[52:end, 1:51])
    return result_1
end

# Compute the result for Part 1
result_1 = solve_part1(input) 
println("Part 1: $result_1")

# Part 2: Find the first step where robots form the Easter egg pattern
function solve_part2(input)
    # Parse the input into robot positions and velocities
    robots = parse_input(input)

    # Simulate the robot movements
    for i in 1:10_000
        # Update robot positions
        step!(robots, (101, 103))
        # Fill the field with the current robot positions
        field = fill_field(robots, (101, 103))

        sum(sum(field, dims=1) .== 0) <= 10 && continue
        sum(sum(field, dims=2) .== 0) <= 10 && continue

        println("Steps: $i")
        
        # Print the field as a visual representation
        ncol, nrow = size(field)
        for i in 1:nrow
            for j in 1:ncol
                if field[j, i] >= 1
                    print("#")  # Represent a robot with '#'
                else
                    print(".")  # Represent an empty tile with '.'
                end
            end
            println() # Move to the next line after printing a row
        end
    end
end

# Compute the result for Part 2
solve_part2(input)