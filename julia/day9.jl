# Read the input file containing the dense representation of the disk map
input = read("inputs/day9", String)

# Function to generate the storage layout from the input
function get_storage(numbs)
    storage = Int[]  # Initialize an empty array to hold the storage layout

    # Iterate through the numbers and their indices
    for (i, n) in enumerate(numbs)
        if (i-1) % 2 == 0  # If the index corresponds to a file block
            append!(storage, fill(((i-1) ÷ 2), n))  # Fill with the file ID
        else  # If the index corresponds to free space
            append!(storage, fill(-1, n))  # Fill with -1 (free space indicator)
        end
    end

    return storage  # Return the storage layout
end

# Part 1: Compact files by moving file blocks to the leftmost free space
function part1(storage)
    sorted = deepcopy(storage)  # Create a copy of the storage layout
    first_empty = findfirst(x -> x == -1, sorted)  # Find the first free space
    last_filled = findlast(x -> x != -1, sorted)  # Find the last filled space

    # Continue until all file blocks are compacted to the left
    while first_empty < last_filled
        # Swap the file block at the last filled position with the first free space
        sorted[first_empty], sorted[last_filled] = sorted[last_filled], sorted[first_empty]
        # Update the indices for the next iteration
        first_empty = findnext(x -> x == -1, sorted, first_empty)
        last_filled = findprev(x -> x != -1, sorted, last_filled)
    end

    # Calculate the checksum for the compacted storage
    ans = sorted[1:findfirst(x -> x == -1, sorted)-1]  # Get all file blocks
    [(i-1)*x for (i, x) in enumerate(ans)] |> sum  # Calculate and return the checksum
end

# Part 2: Compact files by moving entire files to the leftmost free space
function part2(storage)
    sorted = deepcopy(storage)  # Create a copy of the storage layout
    idx = length(sorted)  # Start from the end of the storage

    # Process each file in reverse order
    while !(idx === nothing)
        c = sorted[idx]  # Get the file ID or free space at the current index
        if c == -1  # If it's free space, move to the previous file block
            idx = findprev(x -> x != -1, sorted, idx)
            idx === nothing && break  # Stop if no more file blocks are found
        else  # If it's a file block
            prev_idx = idx  # Store the current index
            idx = findprev(x -> x != c, sorted, idx)  # Find the start of the file
            idx === nothing && break  # Stop if no more file blocks are found
            l = prev_idx - idx  # Calculate the length of the file

            # Find a free space large enough to hold the file
            found_free_space = false
            idx2 = 1  # Start searching from the beginning
            idx3 = 1  # Temporary index for free space search
            while !found_free_space
                idx2 = findnext(x -> x == -1, sorted, idx3)  # Find the next free space
                idx2 === nothing && break  # Stop if no more free space is found
                idx2 >= prev_idx && break  # Stop if free space is to the right of the file
                idx3 = findnext(x -> x != -1, sorted, idx2)  # Find the end of the free space
                idx3 === nothing && break  # Stop if no more free space is found
                l_free_space = idx3 - idx2  # Calculate the length of the free space
                if l_free_space >= l  # Check if the free space is large enough
                    found_free_space = true
                end
            end

            # Move the file if a suitable free space was found
            if found_free_space
                sorted[idx2:idx2+l-1], sorted[idx+1:idx+l] = sorted[idx+1:idx+l], sorted[idx2:idx2+l-1]
            end
        end
    end

    # Calculate the checksum for the final compacted storage
    ans = 0
    for (i, x) in enumerate(sorted)  # Iterate through the storage layout
        if x != -1  # Skip free space blocks
            ans += (i-1) * x  # Add the weighted value of the file block
        end
    end

    return ans  # Return the checksum
end

# Parse the input into an array of integers and generate the storage layout
numbs = parse.(Int, filter(x -> x != '\n', collect(input)))
storage = get_storage(numbs)

# Solve both parts of the problem and print the results
println("Part 1: ", part1(storage))  # Print the result for Part 1
println("Part 2: ", part2(storage))  # Print the result for Part 2