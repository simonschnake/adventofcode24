using DataStructures

# Read the puzzle input lines and convert them into a list of CartesianIndexes representing corrupted coordinates.
# Each line is a comma-separated pair of integers (X,Y), and these coordinates start from (0,0).
# We add +1 to each index because we will reference them using 1-based indexing in a 2D grid (CartesianIndex).
field = map(readlines("inputs/day18")) do line
    CartesianIndex(parse.(Int, split(line, ","))...) + CartesianIndex(1, 1)
end

# Define movement directions as CartesianIndexes for up, right, down, and left.
# Note: Our grid is referenced such that:
#  - UP means decreasing the Y-coordinate
#  - DOWN means increasing the Y-coordinate
#  - RIGHT means increasing the X-coordinate
#  - LEFT means decreasing the X-coordinate
UP, RIGHT, DOWN, LEFT = CartesianIndex(0, -1), CartesianIndex(1, 0), CartesianIndex(0, 1), CartesianIndex(-1, 0)

function dijkstra(field)
    # Perform a Dijkstra's shortest path search to find the minimum number of steps
    # from the start position (1,1) to the goal position (71,71) in a 71x71 grid.
    # 'field' contains the positions of corrupted bytes.
    
    # dist will store the shortest known distance (steps) to each position.
    dist = Dict{CartesianIndex{2}, Int}()
    
    # Priority queue (min-heap) for Dijkstra, storing tuples of (cost, position).
    # We'll always pull out the next position with the smallest known cost.
    pq = MutableBinaryMinHeap{Tuple{Int, CartesianIndex{2}}}()
    
    # Initialize with the start position at cost 0.
    start_pos = CartesianIndex(1, 1)
    dist[start_pos] = 0
    push!(pq, (0, start_pos))

    while !isempty(pq)
        # Get the current position with the smallest cost.
        cur_cost, cur_pos = pop!(pq)

        # Check if this entry is stale (i.e., we found a better path before).
        if dist[cur_pos] < cur_cost
            continue
        end

        # Explore neighbors in the four cardinal directions.
        for dir in [UP, RIGHT, DOWN, LEFT]
            npos = cur_pos + dir
            # If we've reached the goal (71,71), return the cost immediately.
            if npos == CartesianIndex(71, 71)
                return cur_cost + 1
            end
            # Check that npos is within the 71x71 grid.
            npos in CartesianIndices((71,71)) || continue
            # Check if npos is corrupted. If so, skip it.
            npos in field && continue
            # If we found a cheaper path to npos, update and push to the queue.
            if get(dist, npos, Inf) > cur_cost + 1
                dist[npos] = cur_cost + 1
                push!(pq, (cur_cost + 1, npos))
            end
        end
    end

    # If no path is found, return -1.
    return -1
end

function main()
    # Part 1: After simulating the first 1024 bytes, what is the minimum number of steps?
    res1 = dijkstra(field[1:1024])
    println("Part 1: $res1")

    # Part 2: Find the first byte that, once placed, makes it impossible to reach the exit.
    # We simulate incrementally, checking after each added byte if a path exists.
    res2 = CartesianIndex(0, 0)

    for i in eachindex(field)
        dist = dijkstra(field[1:i])
        if dist == -1
            # The path is cut off at this byte. This byte's original coordinates
            # (minus (1,1)) gives the position in 0-based indexing as per the puzzle's instructions.
            res2 = field[i]-CartesianIndex(1, 1)
            break
        end
    end
        
    println("Part 2: $(res2[1]),$(res2[2])")
end

main()