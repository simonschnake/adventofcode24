using DataStructures
input = read("inputs/day20", String)

const UP, RIGHT, DOWN, LEFT = CartesianIndex(0, -1), CartesianIndex(1, 0), CartesianIndex(0, 1), CartesianIndex(-1, 0)

function parse_input(input)
    
    lines = split(input, "\n") |> filter(!isempty)

    ncols = length(lines[1])
    nrows = length(lines)

    # Initialize the grid with zeros
    grid = zeros(Bool, nrows, ncols)
    # Initialize the start and end positions
    start_pos, end_pos = CartesianIndex(1, 1), CartesianIndex(nrows, ncols)

    for (i, line) in enumerate(lines)
        for (j, c) in enumerate(line)
            if c == '#'
                grid[j, i] = false
            elseif c == '.'
                grid[j, i] = true
            elseif c == 'S'
                grid[j, i] = true
                start_pos = CartesianIndex(j, i)
            elseif c == 'E'
                grid[j, i] = true
                end_pos = CartesianIndex(j, i)
            end
        end
    end

    return grid, start_pos, end_pos
end


function distances(grid, start_pos, end_pos)
    # Define distances to end_pos of each cell in the grid that is not a wall
    dist = Dict{CartesianIndex{2}, Int}()
    pq = MutableBinaryMinHeap{Tuple{Int, CartesianIndex{2}}}()

    dist[end_pos] = 0
    push!(pq, (0, end_pos))


    while !isempty(pq)
        cur_cost, cur_pos = pop!(pq)

        if dist[cur_pos] < cur_cost
            continue
        end

        for dir in [UP, RIGHT, DOWN, LEFT]
            npos = cur_pos + dir
            if npos == start_pos
                dist[start_pos] = cur_cost + 1
                break
            end
            checkbounds(Bool, grid, npos) || continue
            grid[npos] || continue
            if get(dist, npos, Inf) > cur_cost + 1
                dist[npos] = cur_cost + 1
                push!(pq, (cur_cost + 1, npos))
            end
        end
    end

    return dist
end

function manhatten_distance(pos1::CartesianIndex{2}, pos2::CartesianIndex{2})
    x1, y1 = pos1.I
    x2, y2 = pos2.I
    return abs(x1 - x2) + abs(y1 - y2)
end

function cheat_gain(dist, max_dist)
    cheat_dist = [] 

    for (pos, value) in dist
        for (npos, nvalue) in dist
            d = manhatten_distance(pos, npos)
            if d > max_dist
                continue
            end
            if pos == npos
                continue
            end
            if nvalue + d < value
                push!(cheat_dist, value - nvalue - d)
            end
        end
    end

    return cheat_dist
end

function main(input)
    grid, start_pos, end_pos = parse_input(input)
    dist = distances(grid, start_pos, end_pos)
    max_dist_part1 = 2
    cheat_dist = cheat_gain(dist, max_dist_part1)
    cheats_better_100_part1 = sum(cheat_dist .≥ 100)
    println("Part 1: $cheats_better_100_part1")
    max_dist_part2 = 20
    cheat_dist = cheat_gain(dist, max_dist_part2)
    cheats_better_100_part2 = sum(cheat_dist .≥ 100)
    println("Part 2: $cheats_better_100_part2")
end

main(input)
