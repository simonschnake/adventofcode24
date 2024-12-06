input = readlines("inputs/day6")

field = hcat(collect.(input)...)

const DIRS = [
    CartesianIndex(0, -1), # up
    CartesianIndex(1, 0),  # right
    CartesianIndex(0, 1),  # down
    CartesianIndex(-1, 0)  # left
]

const start_pos = findfirst(x -> x == '^', field)
const start_dir = 1

function simulate(field)

    visited_pos = Set{CartesianIndex{2}}()
    visited_states = Set{Tuple{CartesianIndex{2}, Int}}()

    pos = start_pos
    dir = start_dir

    push!(visited_pos, pos)
    push!(visited_states, (pos, dir))

    while true
        peak = pos + DIRS[dir]

        if !checkbounds(Bool, field, peak)
            return visited_pos, false
        end

        if field[peak] == '#'
            dir = mod1(dir + 1, 4)
        else
            pos = peak
            push!(visited_pos, pos)
        end

        state = (pos, dir)
        if state in visited_states
            return visited_pos, true
        end
        push!(visited_states, state)

        if !checkbounds(Bool, field, pos)
            return visited_pos, false
        end
    end
end

function part1(field)
    visited_pos, loop_detected = simulate(field)
    println("Part 1: ", length(visited_pos))
end

function part2(field)
    positions, _ = simulate(field)
    possible_pos = filter(x -> x != start_pos, positions)
    possible_pos = collect(possible_pos)

    res = map(possible_pos) do pos
        new_field = deepcopy(field)
        new_field[pos] = '#'
        visited_pos, loop_detected = simulate(new_field)
        loop_detected
    end |> sum

    println("Part 2: ", res)
end

part1(field)
part2(field)