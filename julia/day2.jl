# Read the input file containing the reports, each report is a line of space-separated numbers.
input = readlines("inputs/day2")

# Parse the input into an array of arrays, where each sub-array represents a report of integers.
reports = map(input) do x
    x = split(x, " ")            # Split each line into individual strings (numbers).
    x = parse.(Int, x)           # Convert the strings to integers.
end

# Function to check if a report is "safe".
# A report is safe if the levels are all increasing or all decreasing
# and the difference between any two adjacent levels is between 1 and 3 inclusive.
function report_is_save(report)
    delta = report[2:end] - report[1:end-1]  # Calculate differences between adjacent levels.
    
    # Check if all differences are either positive (increasing) or negative (decreasing).
    if !(all(delta .> 0) || all(delta .< 0))
        return false                         # If not, the report is unsafe.
    end

    delta = abs.(delta)                      # Take the absolute value of the differences.

    # Check if the maximum difference is greater than 3.
    if maximum(delta) > 3
        return false                         # If so, the report is unsafe.
    end

    return true                              # If both conditions are met, the report is safe.
end

# Calculate and print the result for Part 1: Count the number of safe reports.
println("Result Part 1: ", report_is_save.(reports) |> sum)  

# Function to check if a report can be made safe by tolerating a single "bad" level.
function is_save_tolerate_a_single(report)
    # Iterate through each level in the report.
    for i in eachindex(report)
        xd = deleteat!(copy(report), i)      # Remove the i-th level from the report.
        if report_is_save(xd)                # Check if the modified report is safe.
            return true                      # If so, return true.
        end
    end
    return false                             # If no single level can be removed to make it safe, return false.
end

# Calculate and print the result for Part 2: Count the number of reports that are either
# inherently safe or can be made safe by tolerating a single bad level.
println("Result Part 2: ", is_save_tolerate_a_single.(reports) |> sum)