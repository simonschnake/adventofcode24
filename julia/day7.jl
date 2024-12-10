input = readlines("inputs/day7")

lines = map(input) do line
    test_str, rest = split(line, ":")
    test_value = parse(Int, test_str)
    rest_str = split(rest, " ")[2:end]
    values = parse.(Int, rest_str)
    test_value, values
end

function mycat(a, b)
    parse(Int, string(a) * string(b))
end

function process_line(line; part2=false)
    test_value, values = line
    queue = [(values[1], 1)]
    while !isempty(queue)
        value, index = popfirst!(queue)
        if value > test_value
            continue
        end
        if length(values) == index
            if value == test_value
                return true
            else
                continue
            end
        end

        push!(queue, (value + values[index+1], index + 1))
        push!(queue, (value * values[index+1], index + 1))
        if part2
            push!(queue, (mycat(value, values[index+1]), index + 1))
        end
    end
    return false
end

part1 = sum(lines[process_line.(lines)] .|> x -> x[1])
part2 = sum(lines[process_line.(lines, part2=true)] .|> x -> x[1])

println("Part 1: $part1")
println("Part 2: $part2")