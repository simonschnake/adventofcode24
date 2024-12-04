# Read the input for the word search from a file
input = readlines("inputs/day4")

# Convert the input into a 2D character array (field)
field = hcat(collect.(input)...)

# Define all eight possible directions
const DIRECTIONS = [
    (0, 1),   # Right
    (0, -1),  # Left
    (1, 0),   # Down
    (-1, 0),  # Up
    (1, 1),   # Down-Right
    (-1, -1), # Up-Left
    (1, -1),  # Down-Left
    (-1, 1),  # Up-Right
]

# Function to safely retrieve a character from the field
# Returns nothing if indices are out of bounds
function get_char(field, i, j)
    if 1 ≤ i ≤ size(field, 1) && 1 ≤ j ≤ size(field, 2)
        return field[i, j]
    else
        return nothing
    end
end

# Function to count occurrences of a word in all directions
function count_word(field, word)
    count = 0
    nrows, ncols = size(field)
    word_length = length(word)

    for i in 1:nrows
        for j in 1:ncols
            if field[i, j] != word[1]
                continue
            end
            for (di, dj) in DIRECTIONS
                match = true
                for k in 0:word_length - 1
                    ii = i + di * k
                    jj = j + dj * k
                    char = get_char(field, ii, jj)
                    if char != word[k + 1]
                        match = false
                        break
                    end
                end
                if match
                    count += 1
                end
            end
        end
    end
    return count
end

# Part 1: Count occurrences of "XMAS"
num_xmas = count_word(field, "XMAS")
println("Result Part 1: ", num_xmas)

# Function to count "X-MAS" patterns
function count_x_mas_patterns(field)
    count = 0
    nrows, ncols = size(field)

    for i in 2:nrows - 1
        for j in 2:ncols - 1
            if field[i, j] != 'A'
                continue
            end
            # Check both diagonals for "MAS" or "SAM"
            diag1 = [field[i - 1, j - 1], field[i, j], field[i + 1, j + 1]]
            diag2 = [field[i - 1, j + 1], field[i, j], field[i + 1, j - 1]]
            s1 = join(diag1)
            s2 = join(diag2)
            if (s1 == "MAS" || s1 == "SAM") && (s2 == "MAS" || s2 == "SAM")
                count += 1
            end
        end
    end
    return count
end

# Part 2: Count "X-MAS" patterns
num_mas = count_x_mas_patterns(field)
println("Result Part 2: ", num_mas)