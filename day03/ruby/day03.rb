require 'pry'

class Day03
  attr_accessor :map, :map_width, :pos_x, :pos_y

  def initialize
    @map = File.readlines('../input.txt')

    @map_width = map[0].size - 1
    @pos_x = 0
    @pos_y = 0
  end

  def move(x, y, trees)
    # Get the new position
    @pos_x = (pos_x + x) % map_width # Wrap on the width of the map
    @pos_y = pos_y + y
    
    # Base case, we're past the bottom of the map
    return trees if pos_y >= map.size

    case map[pos_y][pos_x]
    when "."
      move(x, y, trees)
    when "#" 
      move(x, y, trees + 1)
    end
  end
end

def main(x, y)
  day03 = Day03.new

  day03.move(x, y, 0)
end

puts main(3, 1)
# part 2
puts main(1, 1) * main(3, 1) * main(5, 1) * main(7, 1) * main(1, 2)
