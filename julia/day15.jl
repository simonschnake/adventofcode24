const WALL, EMPTY, BOX, BOX_LEFT, BOX_RIGHT, ROBOT = '#', '.', 'O', '[', ']', '@'
const DIRS = Dict(
    '>' => CartesianIndex(0, 1),
    '<' => CartesianIndex(0, -1),
    'v' => CartesianIndex(1, 0),
    '^' => CartesianIndex(-1, 0),
)

function parse_input(input)
    field_str, move_str = split(input, "\n\n")

    field_lines = split(field_str, '\n')
    ncol = length(field_lines[1])
    nrow = length(field_lines)


    field = Array{Char}(undef, nrow, ncol)

    for (i, line) in enumerate(field_lines)
        field[i, :] .= collect(line)
    end

    field, move_str
end

function movable(pos, dir, field)
    new_pos = pos + dir
    
    if checkbounds(Bool, field, new_pos) == false
        return false
    end
    if field[new_pos] == WALL
        return false
    end
    if field[new_pos] == EMPTY
        return true
    end

    if field[new_pos] in [BOX, BOX_LEFT, BOX_RIGHT]
        if field[new_pos] == BOX_LEFT && dir in [CartesianIndex(1, 0), CartesianIndex(-1, 0)]
            return movable(new_pos, dir, field) && movable(new_pos + CartesianIndex(0, 1), dir, field)
        elseif field[new_pos] == BOX_RIGHT && dir in [CartesianIndex(1, 0), CartesianIndex(-1, 0)]
            return movable(new_pos, dir, field) && movable(new_pos + CartesianIndex(0, -1), dir, field)
        else
            return movable(new_pos, dir, field)
        end
    end 
    @error "Invalid move"
    return false
end

function move!(pos::CartesianIndex{2}, dir::CartesianIndex{2}, field::Array{Char, 2})
    new_pos = pos + dir

    if field[new_pos] == BOX_LEFT && dir in [CartesianIndex(1, 0), CartesianIndex(-1, 0)]
        move!(new_pos + CartesianIndex(0, 1), dir, field)
    end
    if field[new_pos] == BOX_RIGHT && dir in [CartesianIndex(1, 0), CartesianIndex(-1, 0)]
        move!(new_pos + CartesianIndex(0, -1), dir, field)
    end
    if field[new_pos] ∈ [BOX, BOX_LEFT, BOX_RIGHT]
        move!(new_pos, dir, field)
    end

    field[pos], field[new_pos] = field[new_pos], field[pos]
    return field
end

function run_simulation!(field, move_str)
    pos = findfirst(x -> x == ROBOT, field)

    move_str = filter(x -> x != '\n', move_str)

    for mstr in collect(move_str)
        m = DIRS[mstr]
        if movable(pos, m, field)
            move!(pos, m, field)
            pos += m
        end
        # show_field(field)
    end
end

function show_field(field)
    for i in 1:size(field, 1)
        for j in 1:size(field, 2)
            print(field[i, j])
        end
        println()
    end
end

real_input = read("inputs/day15", String)

test_input_1 = "########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<"

test_input_2 = "##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^"

input = test_input_1

function part1(input)

    field, move_str = parse_input(input)

    show_field(field)
    run_simulation!(field, move_str)

    show_field(field)

    result = 0
    for idx in CartesianIndices(field)
        if field[idx] == BOX
            result += (idx.I[2]-1) + (idx.I[1]-1) * 100
        end
    end

    return result
end

function parse_input2(input)
    field_str, move_str = split(input, "\n\n")

    field_lines = split(field_str, '\n')
    ncol = length(field_lines[1])
    nrow = length(field_lines)


    field = Array{Char}(undef, nrow, ncol*2)

    for (i, line) in enumerate(field_lines)
        for (j, c) in enumerate(collect(line))
            if c == WALL
                a, b = WALL, WALL
            elseif c == EMPTY
                a, b = EMPTY, EMPTY
            elseif c == BOX
                a, b = BOX_LEFT, BOX_RIGHT
            elseif c == ROBOT
                a, b = ROBOT, EMPTY 
            else
                @error "Invalid character"
            end
            field[i, 2*j-1] = a
            field[i, 2*j] = b
        end
    end

    field, move_str
end

function part2(input)
    field, move_str = parse_input2(input)
    run_simulation!(field, move_str)
    
    result = 0
    for idx in CartesianIndices(field)
        if field[idx] ∈ [BOX, BOX_LEFT]
            result += (idx.I[2]-1) + (idx.I[1]-1) * 100
        end
    end

    return result
end

part1(real_input)
part2(real_input)