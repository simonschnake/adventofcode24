input = readlines("inputs/day5")

test_input = split("47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47", '\n')

function parse_input(input)
    split_line_idx = findfirst(x -> x == "", input)

    rule_lines = input[1:split_line_idx-1]

    rules = Dict{Int, Vector{Int}}()

    for line in rule_lines
        first_str, second_str = split(line, "|")
        first_numb = parse(Int, first_str)
        second_numb = parse(Int, second_str)
        rule = getkey(rules, first_numb, Int[])
        if haskey(rules, first_numb)
            push!(rules[first_numb], second_numb)
        else
            rules[first_numb] = [second_numb]
        end
    end 

    number_lines = map(input[split_line_idx+1:end]) do line
        parse.(Int, split(line, ","))
    end

    return rules, number_lines
end


function exercise(rules, number_lines)

    res1 = 0
    res2 = 0



    for numbers in number_lines
        correct_order = false
        initial_correct_order = true

        while !correct_order
            correct_order = true
            for (i1, num1) in enumerate(numbers)
                if i1 == 1
                    continue
                end
                if !haskey(rules, num1)
                    continue
                end
                nums = rules[num1]
                for (i2, num2) in enumerate(numbers[1:i1-1])
                    if num2 in nums
                        correct_order = false
                        initial_correct_order = false
                        numbers[i1], numbers[i2] = numbers[i2], numbers[i1]
                        break
                    end
                end
            end
        end

        if initial_correct_order
            res1 += numbers[length(numbers) ÷ 2 + 1]
        else
            res2 += numbers[length(numbers) ÷ 2 + 1]
        end
    end

    return res1, res2
end


rules, number_lines = parse_input(input)
result_1, result_2 = exercise(rules, number_lines)

println("Result part 1: ", result_1)
println("Result part 2: ", result_2)