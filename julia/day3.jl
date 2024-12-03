input = read("inputs/day3", String)

pattern = r"mul\(\s*(\d+)\s*,\s*(\d+)\s*\)"
matches = eachmatch(pattern, input)

result1 = map(matches) do m
    parse(Int, m.captures[1]) * parse(Int, m.captures[2])
end |> sum

println("Result Part 1: ", result1)

# Part 2

instructions = Dict{Int, Any}()

map(findall("do", input)) do m
    instructions[m |> first] = ("do", 0, 0)
end

map(findall("don't", input)) do m
    instructions[m |> first] = ("don't", 0, 0)
end

map(matches) do m
    instructions[m.offset |> first] = ("mul", parse(Int, m.captures[1]), parse(Int, m.captures[2]))
end

activated = true
result2 = 0

for x in (keys(instructions) |> collect |> sort)
   instr = instructions[x]      
   s = instr[1]
   if s == "do"
       activated = true
    elseif s == "don't"
        activated = false
    else
        if activated
            result2 += instr[2] * instr[3]
        end
    end
end

println("Result Part 2: ", result2)