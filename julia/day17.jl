input = read("inputs/day17", String)

function parse_input(input)
    registers_str, instructions_str = split(input, "\n\n")
    registers = map(split(registers_str, '\n')) do line
        name, value = split(line, ": ")
        parse(Int, value)
    end
    instructions = split(instructions_str[10:end-1], ',') .|> x-> parse(Int, x)
    return registers, instructions
end

function exec(instructions, A, B, C)
    output  = []
    ip = 1
    function combo_op(op)
        if op ∈ [0, 1, 2, 3]
            return op
        elseif op == 4
            return A
        elseif op == 5
            return B
        elseif op == 6
            return C
        end
    end
    while true
        if ip > length(instructions)
            return [output...]
        end 

        instr = instructions[ip]
        op = instructions[ip+1]
        combo = combo_op(op)
        if instr == 0
            #println("A = A($A) ÷ 2^$combo")
            A = A ÷ 2^combo
        elseif instr == 1
            #println("B = B($B) xor $op")
            B = xor(op, B)
        elseif instr == 2
            #println("B = $combo % 8")
            B = combo % 8
        elseif instr == 3
            if A != 0
            #    println("ip = $(op + 1)")
                ip = op + 1
                continue
            end
        elseif instr == 4
            #println("B = B($B) xor C($C)")
            B = xor(B, C)
        elseif instr == 5
            #println("output = $combo % 8")
            output = [output; combo % 8]
        elseif instr == 6
            #println("B = $A ÷ 2^$combo")
            B = A ÷ 2^combo
        elseif instr == 7
            #println("C = $A ÷ 2^$combo")
            C = A ÷ 2^combo
        end
        ip += 2
    end
end

function part1(input)
    registers, instructions = parse_input(input)
    res1 = exec(instructions, registers[1], registers[2], registers[3])
    println("Part 1: ", join(res1, ","))
end

part1(input)

function part2(input)
    """
    This is a hacked solution, that works probably only for my input.
    I observed that the program always repeats until A=0
    In each run B, C are updated based on A, so they begin values are not important.
    In each run A is divided by 8, therefore if we go backwards, the the number mod 8 is always the same.
    We use that to go backwards and find a fitting A.
    """
    i = 0
    eightis = [0] 
    while true
        if last(eightis) == 8
            pop!(eightis)
            eightis[end] += 1
        end
        A = 0
        for x in eightis
            A = A*8 + x
        end
        i += 1
        if i % 10_000 == 0
            @show i, A, eightis
        end
        res = exec(instructions, A, 0, 0)
        if res == instructions[end-length(res)+1:end]
            if length(res) == length(instructions)
                break
            else
                push!(eightis, 0)
            end
        else
            eightis[end] += 1
        end
    end

    A = 0
    for x in eightis
        A = A*8 + x
    end
    println("Part 2: ", A)
end

part1(input)
part2(input)