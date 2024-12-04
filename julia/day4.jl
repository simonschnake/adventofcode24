# Read the input for the word search from a file
input = readlines("inputs/day4")

# Convert the input into a 2D character array (field)
field = hcat(collect.(input)...)

# Global variable to count occurrences of "XMAS"
global num_xmas = 0

# Function to safely retrieve a character from the field
# Returns a space (' ') if indices are out of bounds
function getx(field, i, j)
    if i < 1 || j < 1 || i > size(field, 1) || j > size(field, 2)
        return ' '
    end
    return field[i, j]
end

# Loop through each cell in the field
for i in 1:size(field, 1)  # Iterate through rows
    for j in 1:size(field, 2)  # Iterate through columns
        # Skip cells that are not 'X', as 'XMAS' starts with 'X'
        if field[i, j] != 'X'
            continue
        end
        
        # Check all possible directions for the word "XMAS"
        # Horizontal (right)
        if getx(field, i, j + 1) == 'M' && getx(field, i, j + 2) == 'A' && getx(field, i, j + 3) == 'S'
            global num_xmas += 1
        end
        # Horizontal (left)
        if getx(field, i, j - 1) == 'M' && getx(field, i, j - 2) == 'A' && getx(field, i, j - 3) == 'S'
            global num_xmas += 1
        end
        # Vertical (down)
        if getx(field, i + 1, j) == 'M' && getx(field, i + 2, j) == 'A' && getx(field, i + 3, j) == 'S'
            global num_xmas += 1
        end
        # Vertical (up)
        if getx(field, i - 1, j) == 'M' && getx(field, i - 2, j) == 'A' && getx(field, i - 3, j) == 'S'
            global num_xmas += 1
        end
        # Diagonal (down-right)
        if getx(field, i + 1, j + 1) == 'M' && getx(field, i + 2, j + 2) == 'A' && getx(field, i + 3, j + 3) == 'S'
            global num_xmas += 1
        end
        # Diagonal (up-left)
        if getx(field, i - 1, j - 1) == 'M' && getx(field, i - 2, j - 2) == 'A' && getx(field, i - 3, j - 3) == 'S'
            global num_xmas += 1
        end
        # Diagonal (down-left)
        if getx(field, i + 1, j - 1) == 'M' && getx(field, i + 2, j - 2) == 'A' && getx(field, i + 3, j - 3) == 'S'
            global num_xmas += 1
        end
        # Diagonal (up-right)
        if getx(field, i - 1, j + 1) == 'M' && getx(field, i - 2, j + 2) == 'A' && getx(field, i - 3, j + 3) == 'S'
            global num_xmas += 1
        end
    end
end

# Output the total count of "XMAS" found in the field
println("Result Part 1: ", num_xmas)

# --- Part 2: Finding X-MAS patterns ---
global num_mas = 0  # Initialize counter for "X-MAS" patterns

# Loop through the field, excluding edges for safety in diagonals
for i in 2:size(field, 1) - 1  # Skip the first and last row
    for j in 2:size(field, 2) - 1  # Skip the first and last column
        # Check if the center of a potential X-MAS is 'A'
        if field[i, j] != 'A'
            continue
        end
        # Check diagonals forming an "X" with 'MAS' or 'SAM'
        a = join([field[i-1, j-1], field[i, j], field[i+1, j+1]])
        if a == "MAS" || a == "SAM"
            b = join([field[i-1, j+1], field[i, j], field[i+1, j-1]])
            if b == "MAS" || b == "SAM"
                global num_mas += 1
            end
        end
    end
end

# Output the total count of "X-MAS" patterns found
println("Result Part 2: ", num_mas)