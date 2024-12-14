using RegularExpressions

input = read("inputs/day13", String)

const REG_EXP = r"Button A: X\+(\d+), Y\+(\d+)\nButton B: X\+(\d+), Y\+(\d+)\nPrize: X=(\d+), Y=(\d+)"

function parse_input(input)
    map(split(input, "\n\n")) do claw_mach
        cap = match.(REG_EXP, claw_mach).captures
        if all(x -> x !== nothing, cap)
            x = map(x -> parse(Int, x), cap)
            (a = [x[1], x[2]], b = [x[3], x[4]], prize = [x[5], x[6]])
        else
            nothing
        end
    end
end

function solve(run)
    a,b,prize = run

    p = prize[2] // prize[1]

    n_a, n_b = (b[2] - p * b[1]) // (p * a[1] - a[2]) |> x -> (numerator(x), denominator(x))
    k = prize .÷ (n_a * a + n_b * b)
    solved = k[1] * (n_a * a + n_b * b) - prize
    if solved == [0, 0]
        return k[1] * (n_a * 3 + n_b)
    else
        return 0
    end
end

runs = parse_input(input)

ans1 = solve.(runs) |> sum
println("Part 1: ", ans1)

# part 2

const HIGER_PRIZE = 10000000000000

runs2 = map(runs) do run
    (a = run.a, b = run.b, prize = run.prize .+ HIGER_PRIZE)
end

ans2 = solve.(runs2) |> sum
println("Part 2: ", ans2)