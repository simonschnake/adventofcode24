using DataStructures
real_input = read("inputs/day16", String)

const UP, DOWN, LEFT, RIGHT = CartesianIndex(0, -1), CartesianIndex(0, 1), CartesianIndex(-1, 0), CartesianIndex(1, 0)

function parse_input(input)
    lines = split(input, '\n')
    start_pos, end_pos = CartesianIndex(-1, -1), CartesianIndex(-1, -1)
    ncols = length(lines[1])
    nrows = length(lines)

    field = zeros(Bool, ncols, nrows)

    for (idx, line) in enumerate(lines)
        for (jdx, char) in enumerate(line)
            if char == '.'
                field[jdx, idx] = 0
            elseif char == '#'
                field[jdx, idx] = 1
            elseif char == 'S'
                start_pos = CartesianIndex(jdx, idx)
                field[jdx, idx] = 0
            elseif char == 'E'
                end_pos = CartesianIndex(jdx, idx)
                field[jdx, idx] = 0
            else
                @error "Invalid character"
            end
        end
    end

    field, start_pos, end_pos
end

function min_distance(field, start_pos, end_pos; start_dir=RIGHT, end_dir=-1)
    moves = SortedDict(0 => [(start_pos, RIGHT)])

    moves = MutableBinaryMinHeap([(0, start_pos, start_dir)])

    seen_pos = Set{Tuple{CartesianIndex{2}, CartesianIndex}}()

    i = 0

    while !isempty(moves)
        i += 1
        score, pos, dir = pop!(moves)
        (pos, dir) ∈ seen_pos && continue
        push!(seen_pos, (pos, dir))

        if pos == end_pos
            if dir == end_dir || end_dir == -1
                return score
            end
        end

        if checkbounds(Bool, field, pos + dir) & field[pos + dir] == 0
            push!(moves, (score + 1, pos + dir, dir))
        end

        for d in [UP, DOWN, LEFT, RIGHT]
            if d == dir
                continue
            elseif d == -dir
                push!(moves, (score + 2000, pos, d))
            else
                push!(moves, (score + 1000, pos, d))
            end
        end
            
    end
    -1
end

test_input1 = "###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############"

test_input2 = "#################
#...#...#...#..E#
#.#.#.#.#.#.#.#.#
#.#.#.#...#...#.#
#.#.#.#.###.#.#.#
#...#.#.#.....#.#
#.#.#.#.#.#####.#
#.#...#.#.#.....#
#.#.#####.#.###.#
#.#.#.......#...#
#.#.###.#####.###
#.#.#...#.....#.#
#.#.#.#####.###.#
#.#.#.........#.#
#.#.#.#########.#
#S#.............#
#################"

input = real_input
field, start_pos, end_pos = parse_input(input)
dist = min_distance(field, start_pos, end_pos)

positions = CartesianIndices(field)
positions = positions[field .== false]  # remove walls

on_optimal_path = []
for pos in positions
    @show pos
    for dir in [UP, DOWN, LEFT, RIGHT]
        if min_distance(field, start_pos, pos, end_dir=dir) + min_distance(field, pos, end_pos, start_dir=dir) == dist
            push!(on_optimal_path, pos)
            break
        end
    end
end

length(on_optimal_path)
