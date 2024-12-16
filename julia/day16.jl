using DataStructures

const UP    = CartesianIndex(0, -1)
const DOWN  = CartesianIndex(0,  1)
const LEFT  = CartesianIndex(-1, 0)
const RIGHT = CartesianIndex(1,  0)
DIRECTIONS = [UP, RIGHT, DOWN, LEFT]

function parse_input(input)
    # Parse the input and return:
    # field: A Bool matrix where true = free tile, false = wall
    # start_pos: CartesianIndex of 'S'
    # end_pos: CartesianIndex of 'E'
    lines = split(chomp(input), '\n')
    ncols = length(lines[1])
    nrows = length(lines)

    field = zeros(Bool, ncols, nrows)
    start_pos = CartesianIndex(-1, -1)
    end_pos = CartesianIndex(-1, -1)

    for (y, line) in enumerate(lines)
        for (x, char) in enumerate(line)
            if char == '.'
                field[x, y] = true
            elseif char == '#'
                field[x, y] = false
            elseif char == 'S'
                field[x, y] = true
                start_pos = CartesianIndex(x, y)
            elseif char == 'E'
                field[x, y] = true
                end_pos = CartesianIndex(x, y)
            else
                @error "Invalid character in input."
            end
        end
    end

    return field, start_pos, end_pos
end

function in_bounds_and_free(field, pos)
    # Check if pos is inside field and not a wall
    return checkbounds(Bool, field, pos) && field[pos]
end

function direction_index(dir)
    # Convert a direction vector to an index 1,2,3,4 for [UP, RIGHT, DOWN, LEFT]
    for (i, d) in enumerate(DIRECTIONS)
        if d == dir
            return i
        end
    end
    error("Invalid direction")
end

function neighbors(field, pos, dir)
    # Given a position and direction, return possible next states and their costs.
    # Moves:
    # - Forward: cost = 1 (if no wall)
    # - Turn left/right (90° turn) in place: cost = 1000
    # - Turn around (180° turn) in place: cost = 2000
    #
    # We'll generate up to 5 possible moves:
    # 1) forward move (same direction)
    # 2) turn left (stay in same pos, new dir)
    # 3) turn right (stay in same pos, new dir)
    # 4) turn around (stay in same pos, new dir)
    # We represent directions cyclically: UP=0, RIGHT=1, DOWN=2, LEFT=3

    cur_dir_idx = direction_index(dir)

    # Forward move if possible
    forward_pos = pos + dir
    moves = []
    if in_bounds_and_free(field, forward_pos)
        push!(moves, (forward_pos, dir, 1)) # move forward costs 1
    end

    # Turns do not move position, only direction:
    # Turning left: index (cur_dir_idx - 1) mod 4
    left_dir = DIRECTIONS[mod1(cur_dir_idx - 1, 4)]
    push!(moves, (pos, left_dir, 1000))

    # Turning right: index (cur_dir_idx + 1) mod 4
    right_dir = DIRECTIONS[mod1(cur_dir_idx + 1, 4)]
    push!(moves, (pos, right_dir, 1000))

    # Turning around: (cur_dir_idx + 2) mod 4
    around_dir = DIRECTIONS[mod1(cur_dir_idx + 2, 4)]
    push!(moves, (pos, around_dir, 2000))

    return moves
end

function dijkstra(field; start_positions=[], start_costs=[])
    # A generic Dijkstra that, given a field, a set of start states (pos,dir)
    # with initial costs, computes the minimal cost to every reachable state.
    #
    # State is (pos, dir).
    # We'll store distances in a dictionary: dist[(pos,dir)] = minimal_cost
    #
    # Arguments:
    # - field: 2D boolean array (true=wall, false=free)
    # - start_positions: array of tuples (pos, dir)
    # - start_costs: array of costs corresponding to each start position
    #
    # Returns:
    # dist: a dictionary mapping (pos, dir) to minimal cost

    dist = Dict{Tuple{CartesianIndex{2}, CartesianIndex{2}}, Int}()
    pq = MutableBinaryMinHeap{Tuple{Int, CartesianIndex{2}, CartesianIndex{2}}}()

    # Initialize priority queue with start states
    for i in 1:length(start_positions)
        pos, dir = start_positions[i]
        c = start_costs[i]
        dist[(pos, dir)] = c
        push!(pq, (c, pos, dir))
    end

    while !isempty(pq)
        cur_cost, cur_pos, cur_dir = pop!(pq)

        # If this cost is not equal to dist for this state, it's a stale entry
        if dist[(cur_pos, cur_dir)] < cur_cost
            continue
        end

        # Explore neighbors
        for (npos, ndir, move_cost) in neighbors(field, cur_pos, cur_dir)
            new_cost = cur_cost + move_cost
            if get(dist, (npos, ndir), Inf) > new_cost
                dist[(npos, ndir)] = new_cost
                push!(pq, (new_cost, npos, ndir))
            end
        end
    end

    return dist
end

# Wrapper to run Dijkstra from the start position and direction = RIGHT
function distances_from_start(field, start_pos)
    # Start facing East (RIGHT)
    start_dir = RIGHT
    dijkstra(field; start_positions=[(start_pos, start_dir)], start_costs=[0])
end

# Wrapper to run Dijkstra from the end position
# We consider all directions at the end as a starting point with 0 cost,
# since we want to find the minimal cost from any direction at the end.
function distances_from_end(field, end_pos)
    start_positions = [(end_pos, d) for d in DIRECTIONS]
    start_costs = [0,0,0,0]
    dijkstra(field; start_positions=start_positions, start_costs=start_costs)
end

####################################
# Main code to tie it all together #
####################################

function main()

    input = read("inputs/day16", String)

    field, start_pos, end_pos = parse_input(input)

    # Compute distances from start and end
    dist_from_start = distances_from_start(field, start_pos)
    dist_from_end = distances_from_end(field, end_pos)

    # Minimal cost to reach end:
    min_cost = minimum([dist_from_start[(end_pos, d)] for d in DIRECTIONS])

    # Closure test from end
    dist_from_start[(start_pos, RIGHT)] + dist_from_end[(start_pos, -RIGHT)]

    on_optimal_path = Set()
    for pos in CartesianIndices(field)
        for dir in DIRECTIONS
            if haskey(dist_from_start, (pos, dir)) && haskey(dist_from_end, (pos, dir))
                if min_cost == dist_from_start[(pos, dir)] + dist_from_end[(pos, -dir)]
                    push!(on_optimal_path, pos)
                end
            end
        end
    end

    on_optimal_path

    println("Part 1: ", min_cost)
    println("Part 2: ", length(on_optimal_path))
end

main()
