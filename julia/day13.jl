# Define a struct to represent each claw machine's configuration
struct ClawMachine
    button_a :: Tuple{Int, Int}  # (X movement, Y movement) for Button A
    button_b :: Tuple{Int, Int}  # (X movement, Y movement) for Button B
    prize_x :: Int               # X-coordinate of the prize
    prize_y :: Int               # Y-coordinate of the prize
end

# Regular expression pattern to parse each claw machine's configuration
const MACHINE_REGEX = r"Button A: X\+(\d+), Y\+(\d+)\nButton B: X\+(\d+), Y\+(\d+)\nPrize: X=(\d+), Y=(\d+)"

# Offset to adjust prize positions for Part 2
const OFFSET = 10_000_000_000_000

# Function to parse the input text and return a vector of ClawMachine instances
function parse_input(input::String)::Vector{ClawMachine}
    machines = Vector{ClawMachine}()

    # Split the input into blocks separated by two newlines
    for block in split(input, "\n\n")
        # Attempt to match the regex pattern
        m = match(MACHINE_REGEX, block)
        if m !== nothing
            captures = m.captures
            # Parse captured strings into integers
            button_a_x = parse(Int, captures[1])
            button_a_y = parse(Int, captures[2])
            button_b_x = parse(Int, captures[3])
            button_b_y = parse(Int, captures[4])
            prize_x = parse(Int, captures[5])
            prize_y = parse(Int, captures[6])

            # Create a ClawMachine instance and add it to the list
            push!(machines, ClawMachine(
                (button_a_x, button_a_y),
                (button_b_x, button_b_y),
                prize_x,
                prize_y
            ))
        else
            @warn "Failed to parse machine configuration: $block"
        end
    end

    return machines
end

# Function to solve for the minimum tokens required to win the prize for a single machine
function solve_machine(machine::ClawMachine)::Int
    # Extract button movements and prize position
    (a_x, a_y) = machine.button_a
    (b_x, b_y) = machine.button_b
    (p_x, p_y) = (machine.prize_x, machine.prize_y)

    # Set up the system of linear equations:
    # a_x * n_a + b_x * n_b = p_x
    # a_y * n_a + b_y * n_b = p_y

    # Calculate the determinant
    det = a_x * b_y - a_y * b_x
    if det == 0
        # The system has no unique solution
        return 0
    end

    # Use Cramer's Rule to solve for n_a and n_b
    n_a = (p_x * b_y - p_y * b_x) / det
    n_b = (a_x * p_y - a_y * p_x) / det

    # Check if solutions are non-negative integers
    if n_a >= 0 && n_b >= 0 && isinteger(n_a) && isinteger(n_b)
        # Calculate the total cost: 3 tokens for each Button A press and 1 token for each Button B press
        total_cost = Int(n_a) * 3 + Int(n_b) * 1
        return total_cost
    else
        # No valid solution exists
        return 0
    end
end

# Function to solve all machines and sum their minimum token costs
function solve_all(machines::Vector{ClawMachine})::Int
    return sum(solve_machine.(machines))
end

# Main execution flow
function main()
    # Read the input file
    input = read("inputs/day13", String)

    # Parse the input into claw machines
    machines = parse_input(input)

    # Part 1: Solve with original prize positions
    ans1 = solve_all(machines)
    println("Part 1: ", ans1)

    # Part 2: Adjust prize positions by adding 10^13 and solve

    adjusted_machines = ClawMachine[]
    for machine in machines
        push!(adjusted_machines, ClawMachine(
            machine.button_a,
            machine.button_b,
            machine.prize_x + OFFSET,
            machine.prize_y + OFFSET
        ))
    end

    ans2 = solve_all(adjusted_machines)
    println("Part 2: ", ans2)
end

# Execute the main function
main()