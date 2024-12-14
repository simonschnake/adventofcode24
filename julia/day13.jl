# Import the RegularExpressions module for pattern matching
using RegularExpressions

# Read the puzzle input file as a single string
input = read("inputs/day13", String)

# Define a regular expression to parse each machine's configuration
const REG_EXP = r"Button A: X\+(\d+), Y\+(\d+)\nButton B: X\+(\d+), Y\+(\d+)\nPrize: X=(\d+), Y=(\d+)"

# Function to parse the input and extract machine configurations
function parse_input(input)
    # Split the input into blocks for each machine, separated by double newlines
    map(split(input, "\n\n")) do claw_mach
        # Match the regular expression to the block and extract the captures
        cap = match.(REG_EXP, claw_mach).captures
        # If all captures are valid, parse them into integers and structure the data
        if all(x -> x !== nothing, cap)
            x = map(x -> parse(Int, x), cap)
            # Return a tuple containing the button vectors and prize position
            (a = [x[1], x[2]], b = [x[3], x[4]], prize = [x[5], x[6]])
        else
            # Return nothing if the parsing fails
            nothing
        end
    end
end

# Function to solve for the minimum tokens required for a machine's configuration
function solve(run)
    # Decompose the machine's configuration into button vectors and prize position
    a, b, prize = run

    # Calculate the slope of the prize position (Y / X)
    p = prize[2] // prize[1]

    # Solve for the number of presses (n_a for Button A, n_b for Button B)
    n_a, n_b = (b[2] - p * b[1]) // (p * a[1] - a[2]) |> x -> (numerator(x), denominator(x))
    
    # Calculate the scalar multipliers for the button presses
    k = prize .÷ (n_a * a + n_b * b)

    # Verify the solution by checking the resulting claw position matches the prize
    solved = k[1] * (n_a * a + n_b * b) - prize

    # Return the minimum cost if the solution is valid, otherwise return 0
    if solved == [0, 0]
        return k[1] * (n_a * 3 + n_b)
    else
        return 0
    end
end

# Parse the input data into machine configurations
runs = parse_input(input)

# Solve for the total minimum tokens required for all machines (Part 1)
ans1 = solve.(runs) |> sum
println("Part 1: ", ans1)

# Part 2: Add a large offset to all prize positions and recalculate
const HIGER_PRIZE = 10000000000000

runs2 = map(runs) do run
    # Adjust the prize position for each machine
    (a = run.a, b = run.b, prize = run.prize .+ HIGER_PRIZE)
end

# Solve for the total minimum tokens required with adjusted prize positions (Part 2)
ans2 = solve.(runs2) |> sum
println("Part 2: ", ans2)