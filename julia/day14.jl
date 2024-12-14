input = read("inputs/day14", String)

function parse_input(input)
    lines = split(input, '\n')
    filter!(!isempty, lines)
    map(lines) do line
        a, b = split(line, " v=")
        p = split(a[3:end], ",") .|> x -> parse(Int, x)
        v = split(b, ",") .|> x -> parse(Int, x)
        p .+= 1 # 1-indexed
        p, v
    end
end


function step!(robots, field_size)
    for robot in robots
        robot[1] .+= robot[2]
        robot[1][1] = mod1(robot[1][1], field_size[1])
        robot[1][2] = mod1(robot[1][2], field_size[2])
    end
end

function fill_field(robots, field_size)
    field = zeros(Int, field_size...)
    for robot in robots
        pos = robot[1]
        field[pos[1], pos[2]] += 1
    end
    field
end

# Part 1 
function solve_part1(input)
    robots =  parse_input(input)
    field = fill_field(robots, (101, 103))

    result_1 = sum(field[1:50, 1:51]) * sum(field[52:end, 53:end]) * sum(field[1:50, 53:end]) * sum(field[52:end, 1:51])
    return result_1
end

result_1 = solve_part1(input) 
println("Part 1: $result_1")

# Part 2

function solve_part2(input)

    robots =  parse_input(input)

    for i in 1:10_000
        step!(robots, (101, 103))
        field = fill_field(robots, (101, 103))

        sum(sum(field, dims=1) .== 0) <= 10 && continue
        sum(sum(field, dims=2) .== 0) <= 10 && continue

        println("Steps: $i")
        ncol, nrow = size(field)
        for i in 1:nrow
            for j in 1:ncol
                if field[j, i] >= 1
                    print("#")
                else
                    print(".")
                end
            end
            println()
        end
    end
end

solve_part2(input)





