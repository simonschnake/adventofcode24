input = readlines("inputs/day4")

input = split("MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX", "\n")

field = hcat(collect.(input)...)

num_xmas = 0

function getx(field, i, j)
    if i < 1 || j < 1 || i > size(field, 1) || j > size(field, 2)
        return ' '
    end
    return field[i, j]
end

for i in 1:size(field, 1)
    for j in 1:size(field, 2)
        if field[i, j] != 'X'
            continue
        end
        # horizontal
        if getx(field, i, j + 1) == 'M' && getx(field, i, j + 2) == 'A' && getx(field, i, j + 3) == 'S'
            num_xmas += 1
        end
        # horizontal reverse
        if getx(field, i, j - 1) == 'M' && getx(field, i, j - 2) == 'A' && getx(field, i, j - 3) == 'S'
            num_xmas += 1
        end
        # vertical
        if getx(field, i + 1, j) == 'M' && getx(field, i + 2, j) == 'A' && getx(field, i + 3, j) == 'S'
            num_xmas += 1
        end
        # vertical reverse
        if getx(field, i - 1, j) == 'M' && getx(field, i - 2, j) == 'A' && getx(field, i - 3, j) == 'S'
            num_xmas += 1
        end
        # diagonal
        if getx(field, i + 1, j + 1) == 'M' && getx(field, i + 2, j + 2) == 'A' && getx(field, i + 3, j + 3) == 'S'
            num_xmas += 1
        end
        # diagonal reverse
        if getx(field, i - 1, j - 1) == 'M' && getx(field, i - 2, j - 2) == 'A' && getx(field, i - 3, j - 3) == 'S'
            num_xmas += 1
        end
        # diagonal 180
        if getx(field, i + 1, j - 1) == 'M' && getx(field, i + 2, j - 2) == 'A' && getx(field, i + 3, j - 3) == 'S'
            num_xmas += 1
        end
        # diagonal 180 reverse
        if getx(field, i - 1, j + 1) == 'M' && getx(field, i - 2, j + 2) == 'A' && getx(field, i - 3, j + 3) == 'S'
            num_xmas += 1
        end
    end
end 

num_xmas

# 2

num_mas = 0

for i in 2:size(field, 1)-1
    for j in 2:size(field, 2)-1
        if field[i, j] != 'A'
            continue
        end
        a = join([field[i-1, j-1], field[i, j], field[i+1, j+1]])
        if a == "MAS" || a == "SAM"
            b = join([field[i-1, j+1], field[i, j], field[i+1, j-1]])
            if b == "MAS" || b == "SAM"
                num_mas += 1
            end
        end
    end
end

num_mas