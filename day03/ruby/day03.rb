require 'pry'

class Day03
  attr_accessor :map, :map_width, :pos_x, :pos_y

  TREE = '#'

  def initialize
    @map = File.readlines('../input.txt')
  end

  def count_trees(slope)
    (x, y) = slope
    self.reset
    self.move(x, y, 0)
  end

  private

  def reset
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
    return move(x, y, trees + 1) if map[pos_y][pos_x] == TREE
    move(x, y, trees)
  end
end

# puts main(3, 1)
main = Day03.new

puts main.count_trees([3, 1])
# part 2
slopes = 
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2],
]
puts slopes.map { |slope| main.count_trees(slope) }.reduce(:*)
