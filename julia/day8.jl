input = readlines("inputs/day8")

function to_field(input)
    field = hcat(map(input) do line
        collect.(line)
    end...)
end

function solve_day8(field)
    ncol, nrow = size(field)

    antennas = Dict{Char, Vector{CartesianIndex{2}}}()

    for i in 1:nrow, j in 1:ncol
        if field[i, j] != '.'
            push!(
                get!(antennas, field[i, j], Vector{CartesianIndex{2}}()),
                CartesianIndex(i, j)
            )
        end
    end

    antennas

    antinode_part1 = Set{CartesianIndex{2}}()
    antinode_part2 = Set{CartesianIndex{2}}()

    for c in CartesianIndices(field)
        x,y = c.I
        for (_, positions) in antennas
            for i in 1:length(positions), j in 1:length(positions)
                if positions[i] == positions[j]
                    continue
                end
                x1, y1 = positions[i].I
                x2, y2 = positions[j].I

                d1 = abs(x - x1) + abs(y - y1)
                d2 = abs(x - x2) + abs(y - y2)

                dx1 = x - x1
                dx2 = x - x2
                dy1 = y - y1
                dy2 = y - y2

                if (d1 == 2*d2 || d1 == d2*2) && (dx1*dy2 == dx2*dy1)
                    push!(antinode_part1, c)
                end
                if dx1*dy2 == dx2*dy1
                    push!(antinode_part2, c)
                end
            end
        end
    end

    antinode_part1, antinode_part2
end

field = to_field(input)
antinode_part1, antinode_part2 = solve_day8(field)

println("Part 1: ", length(antinode_part1))
println("Part 2: ", length(antinode_part2))