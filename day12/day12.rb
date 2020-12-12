require 'benchmark'
require 'pry'

class Day12
  DIRECTIONS = {
    'N' => 0,
    'E' => 1,
    'S' => 2,
    'W' => 3,
  }
  DIRECTIONS_OFFSET = { # [x,y]
    0 => [0,-1],
    1 => [1,0],
    2 => [0,1],
    3 => [-1,0],
  }

  attr_accessor :current_direction, :position, :waypoint

  def initialize(path)
    @instructions = File.readlines(path).map(&:strip)
    @current_direction = DIRECTIONS['E']
    @position = [0,0]
  end

  def rotate(direction, degree)
    direction_modifier = direction == 'L' ? -1 : 1
    turns = ( degree / 90 ) * direction_modifier

    @current_direction = ( current_direction + turns ) % 4
  end

  def direction_offset(direction)
    if direction == 'F'
      DIRECTIONS_OFFSET[current_direction]
    else
      DIRECTIONS_OFFSET[DIRECTIONS[direction]]
    end
  end

  def move(direction, units)
    offset = [direction_offset(direction)[0] * units, direction_offset(direction)[1] * units]

    @position = [position[0] + offset[0], position[1] + offset[1]]
  end

  def part1
    @instructions.each do |line|
      action = line[0]
      units = line[1..].to_i

      case action
      when 'L', 'R'
        rotate(action, units)
      else
        move(action, units)
      end
    end

    position[0].abs + position[1].abs
  end

  # ----------

  def part2_move(action, units)
    if action == 'F'
      @position = [position[0] + (waypoint[0] * units), position[1] + (waypoint[1] * units)]
    else
      offset = DIRECTIONS_OFFSET[DIRECTIONS[action]]
      @waypoint = [waypoint[0] + (offset[0] * units), waypoint[1] + (offset[1] * units)]
    end
  end

  def part2_rotate(action, units)
    turns = ( units / 90 ) % 4
    @waypoint = if action == 'L'
      case turns
      when 1 
        [waypoint[1], -waypoint[0]]
      when 2 
        [-waypoint[0], -waypoint[1]]
      when 3 
        [-waypoint[1], waypoint[0]]
      end
    else
      case turns
      when 1 
        [-waypoint[1], waypoint[0]]
      when 2 
        [-waypoint[0], -waypoint[1]]
      when 3 
        [waypoint[1], -waypoint[0]]
      end
    end
  end

  def part2
    @waypoint = [10, -1]
    @position = [0, 0]

    @instructions.each do |line|
      action = line[0]
      units = line[1..].to_i

      case action
      when 'L', 'R'
        part2_rotate(action, units)
      else
        part2_move(action, units)
      end
    end

    position[0].abs + position[1].abs
  end
end

path = 'input.txt'
day12 = Day12.new(path)

if ARGV.include?('--benchmark')
  Benchmark.bmbm do |x|
    x.report('part1') { day12.part1 }
    x.report('part2') { day12.part2 }
  end
else
  puts day12.part1
  puts day12.part2
end

