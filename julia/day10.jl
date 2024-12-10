input = read("inputs/day10", String)

function to_field(input)
    lines = split(input, "\n")
    filter!(x -> length(x) > 0, lines)
    field = hcat(map(lines) do line
        collect.(line)
    end...)
    parse.(Int, field)
end

function start_positions(field)
    findall(x -> x == 0, field)
end

function neighbours(field, c)
    return [
        c + CartesianIndex(1, 0),
        c + CartesianIndex(-1, 0),
        c + CartesianIndex(0, 1),
        c + CartesianIndex(0, -1),
    ]
end

function check_routes(field)

    queue = [(c, 0, [c]) for c in start_positions(field)]

    routes = Set{Vector{CartesianIndex{2}}}()

    while !isempty(queue)
        (c, d, r) = popfirst!(queue)
        if field[c] == 9
            push!(routes, r)
        else
            for n in neighbours(field, c)
                if checkbounds(Bool, field, n) && field[n] == d + 1
                    push!(queue, (n, d + 1, [r; n]))
                end
            end
        end
    end

    return routes
end



field = to_field(input)
routes = check_routes(field)
result_part1 = length(Set([(first(r), last(r)) for r in routes]))
result_part2 = length(routes)

println("Part 1: $result_part1")
println("Part 2: $result_part2")
