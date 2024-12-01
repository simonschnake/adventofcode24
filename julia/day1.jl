input = readlines("inputs/day1")

x = hcat(map(input) do x
    x = split(x, "   ")
    x = parse.(Int, x) 
end...)

####### Part 1 #######

a = sort(x[1, :])
b = sort(x[2, :])

println("Result Part 1: ", sum(abs.(a .- b)))

####### Part 2 #######

d = Dict()

d[a] = map(a) do x
    count(y -> y == x, b)
end

println("Result Part 2: ", sum(a .* d[a]))