real_input = read("inputs/day19", String)
test_input = "r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb"

function parse_input(input)
    lines = split(input, "\n") |> filter(!isempty)
    towels = split(first(lines), ", ")
    sort!(towels, by=length, rev=true)
    designs = lines[2:end]
    return towels, designs
end

CACHE1 = Dict{String, Bool}()
function has_match(design, towels)
    if haskey(CACHE1, design)
        return CACHE1[design]
    end
    if isempty(design)
        return true
    end
    ans = false
    for towel in towels
        if startswith(design, towel) && has_match(design[length(towel)+1:end], towels)
            ans = true
        end
    end
    CACHE1[design] = ans
    return ans
end


CACHE2 = Dict{String, Int}()
function num_matches(design, towels)
    if haskey(CACHE2, design)
        return CACHE2[design]
    end
    if isempty(design)
        return 1
    end
    ans = 0
    for towel in towels
        if startswith(design, towel)
            ans += num_matches(design[length(towel)+1:end], towels)
        end
    end
    CACHE2[design] = ans
    return ans
end

function main(input)
    towels, designs = parse_input(input)
    part1 = [has_match(design, towels) for design in designs] |> sum
    part2 = [num_matches(design, towels) for design in designs] |> sum
    println("Part 1: $part1")
    println("Part 2: $part2")
end

main(real_input)