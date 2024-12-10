input = read("inputs/day9", String)


function get_storage(numbs)

    storage = Int[]

    for (i, n) in enumerate(numbs)
        if (i-1) % 2 == 0 # file
            append!(storage, fill(((i-1)÷2), n))
        else # free space
            append!(storage, fill(-1, n))
        end
    end

    return storage
end


# Part 1
function part1(storage)
    sorted = deepcopy(storage)
    first_empty = findfirst(x -> x == -1, sorted)
    last_filled = findlast(x -> x != -1, sorted)

    while first_empty < last_filled
        sorted[first_empty], sorted[last_filled] = sorted[last_filled], sorted[first_empty]
        first_empty = findnext(x -> x == -1, sorted, first_empty)
        last_filled = findprev(x -> x != -1, sorted, last_filled)
    end

    ans = sorted[1:findfirst(x -> x == -1, sorted)-1]

    [(i-1)*x for (i, x) in enumerate(ans)] |> sum
end


function part2(storage)

    sorted = deepcopy(storage)

    idx = length(sorted)

    while !(idx === nothing)
        c = sorted[idx]
        if c == -1 # free space, go to next block of files
            idx = findprev(x -> x != -1, sorted, idx)
            idx === nothing && break
        else # file, move to next free space
            prev_idx = idx
            idx = findprev(x -> x != c, sorted, idx)
            idx === nothing && break
            l = prev_idx - idx
            # find free space from beginning of sorted2 
            # that is large enough to hold the file
            found_free_space = false
            idx2 = 1  
            idx3 = 1
            while !found_free_space
                idx2 = findnext(x -> x == -1, sorted, idx3)
                idx2 === nothing && break
                idx2 >= prev_idx && break
                idx3 = findnext(x -> x != -1, sorted, idx2)
                idx3 === nothing && break
                l_free_space = idx3 - idx2
                if l_free_space >= l
                    found_free_space = true
                end
            end

            if found_free_space
                sorted[idx2:idx2+l-1], sorted[idx+1:idx+l] = sorted[idx+1:idx+l], sorted[idx2:idx2+l-1]
            end
        end
    end

    ans = 0

    for (i, x) in enumerate(sorted)
        if x != -1
            ans += (i-1)*x
        end
    end

    return ans
end


numbs = parse.(Int, filter(x -> x != '\n', collect(input)))
storage = get_storage(numbs)
println("Part 1: ", part1(storage))
println("Part 2: ", part2(storage))