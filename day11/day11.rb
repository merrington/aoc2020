require 'benchmark'
require 'pry'

class Day11
  FLOOR = '.'.freeze
  EMPTY = 'L'.freeze
  OCCUPIED = '#'.freeze

  def initialize(path)
    @map = File.readlines(path).map { |l| l.strip.split('') }
  end

  def print_map(map = @map)
    puts map.map(&:join)
  end

  def occupied_nearby(x, y, map)
    [-1,0,1].reduce(0) do |occupied, x_offset|
      [-1,0,1].reduce(occupied) do |occupied, y_offset|
        if (x_offset == 0 && y_offset == 0) ||
          (y + y_offset < 0) || (y + y_offset >= map.size) ||
          (x + x_offset < 0) || (x + x_offset >= map[y+y_offset].size)
          # current seat or out of bounds
          occupied
        else
          occupied + (map[y + y_offset][x + x_offset] == OCCUPIED ? 1 : 0)
        end
      end
    end
  end

  def part1(map = @map)
    new_map = []

    map.each_with_index do |row, y_index|
      row.each_with_index do |seat, x_index|
        nearby = occupied_nearby(x_index, y_index, map)
        new_seat = if seat == EMPTY && nearby == 0
          OCCUPIED
        elsif seat == OCCUPIED && nearby >= 4
          EMPTY
        else
          seat.dup
        end

        new_map[y_index] = [] if new_map[y_index].nil?
        new_map[y_index][x_index] = new_seat
      end
    end

    if new_map == map
      new_map.reduce(0) do |occupied, row|
        row.reduce(occupied) { |occupied, seat| occupied + (seat == OCCUPIED ? 1 : 0) }
      end
    else
      part1(new_map)
    end
  end

  # ... this is so ugly, and ridiculously slow

  def part2_occupied_nearby(x, y, map)
    directions = [ # [y,x] defined clockwise, starting at 12
      [-1,0],
      [-1,1],
      [0,1],
      [1,1],
      [1,0],
      [1,-1],
      [0,-1],
      [-1,-1],
    ]
    directions.reduce(0) do |occupied, offset|
      dir_x = x
      dir_y = y
      found = loop do
        dir_y += offset[0]
        dir_x += offset[1]

        break EMPTY if dir_y < 0 || dir_y >= map.size || dir_x < 0 || dir_x >= map[dir_y].size
        break map[dir_y][dir_x] if map[dir_y][dir_x] != FLOOR
      end
      occupied + ( found == OCCUPIED ? 1 : 0 )
    end
  end

  def part2(map = @map)
    new_map = []

    map.each_with_index do |row, y_index|
      row.each_with_index do |seat, x_index|
        nearby = part2_occupied_nearby(x_index, y_index, map)
        new_seat = if seat == EMPTY && nearby == 0
          OCCUPIED
        elsif seat == OCCUPIED && nearby >= 5
          EMPTY
        else
          seat.dup
        end

        new_map[y_index] = [] if new_map[y_index].nil?
        new_map[y_index][x_index] = new_seat
      end
    end

    if new_map == map
      new_map.reduce(0) do |occupied, row|
        row.reduce(occupied) { |occupied, seat| occupied + (seat == OCCUPIED ? 1 : 0) }
      end
    else
      part2(new_map)
    end
  end
end

path = 'input.txt'
day11 = Day11.new(path)

if ARGV.include?('--benchmark')
  Benchmark.bmbm do |x|
    x.report('part1') { day11.part1 }
    x.report('part2') { day11.part2 }
  end
else
  puts day11.part1
  puts day11.part2
end

