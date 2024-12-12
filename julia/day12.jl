input = read("inputs/day12", String)

function to_field(input)
    lines = split(input, '\n')
    filter!(x -> x != "", lines)
    hcat(map(lines) do line
        collect.(line)
    end...)
end

const UP = CartesianIndex(0, -1)
const DOWN = CartesianIndex(0, 1)
const LEFT = CartesianIndex(-1, 0)
const RIGHT = CartesianIndex(1, 0)

const DIRS = [UP, DOWN, LEFT, RIGHT]


function calc(field)
    seen = Set{CartesianIndex{2}}()
    ans1 = 0
    ans2 = 0
    for pos in CartesianIndices(field)
        if pos in seen
            continue
        end
        c = field[pos]
        area = Set([pos])
        n_perim = 0
        perim = Set()
        queue = [pos]
        while length(queue) > 0
            pos = pop!(queue)
            for dir in DIRS
                new_pos = pos .+ dir
                if checkbounds(Bool, field, new_pos) && field[new_pos] == c # in area
                    if new_pos in area
                        continue
                    end
                    push!(queue, new_pos)
                    push!(area, new_pos)
                else
                    push!(perim, (new_pos, dir))
                    n_perim += 1
                end
            end
        end

        sides = 0 

        while length(perim) > 0
            pos, dir = pop!(perim)
            sides += 1
            queue = [pos] 
            while length(queue) > 0
                pos = pop!(queue)
                new_pos = pos .+ DIRS
                filter!(x -> (x, dir) in perim, new_pos)
                for p in new_pos
                    push!(queue, p)
                    delete!(perim, (p, dir))
                end
            end
        end
        
        union!(seen, area)
        n_area = length(area)
        ans1 += n_area * n_perim
        ans2 += n_area * sides
    end
    ans1, ans2
end

field = to_field(input)
part1, part2 = calc(field)

println("Part 1: $part1")
println("Part 2: $part2")

