require 'benchmark'
require 'pry'

class Day17
  attr_accessor :file, :path, :active
  ACTIVE = true
  INACTIVE = false

  def initialize(path)
    @path = path
    @file = File.open(path)
    @active = {}

    file.readlines.each_with_index do |line, line_number|
      line.strip.chars.each_with_index.map do |char, index| 
        active[to_key(index, line_number, 0, 0)] = ACTIVE if char == '#'
      end
    end
  end

  def to_key(x,y,z,w)
    "#{x},#{y},#{z},#{w}"
  end

  def from_key(key)
    key.split(',').map(&:to_i)
  end

  # not updated for pt 2
  def print_map
    all_active = active.keys.map { |k| from_key(k) }
    # find min/max of each coordinate
    all_x = all_active.map { |k| k[0] }
    all_y = all_active.map { |k| k[1] }
    all_z = all_active.map { |k| k[2] }

    (all_z.min..all_z.max).each do |z|
      puts "z = #{z}"
      (all_y.min..all_y.max).each do |y|
        (all_x.min..all_x.max).each do |x|
          print active[to_key(x, y, z)] ? '#' : '.'
        end
        print "  y = #{y}\n"
      end
      print "\n"
    end
  end

  def neighbors(x, y, z, w)
    [-1,0,1].reduce(0) do |count, x_offset|
      [-1,0,1].reduce(count) do |count, y_offset|
        [-1,0,1].reduce(count) do |count, z_offset|
          [-1,0,1].reduce(count) do |count, w_offset|
            next count if x_offset == 0 && y_offset == 0 && z_offset == 0 && w_offset == 0
            count += active[to_key(x + x_offset, y + y_offset, z + z_offset, w + w_offset)] == ACTIVE ? 1 : 0
          end
        end
      end
    end
  end

  def part1
    #print_map
    (1..6).each do |cycle|
      changes = {}

      # test all keys around existing active keys, there will be some duplication but 🤷‍♂️
      active.keys.each do |key|
        x, y, z, w = from_key(key)
    
        [-1,0,1].each do |x_offset|
          [-1,0,1].each do |y_offset|
            [-1,0,1].each do |z_offset|
              [-1,0,1].each do |w_offset|
                test_coordinates = [x + x_offset, y + y_offset, z + z_offset, w + w_offset]
                test_key = to_key(*test_coordinates)
  
                n = neighbors(*test_coordinates)
                if active[test_key] && (n < 2 || n > 3)
                  changes[test_key] = INACTIVE
                elsif !active[test_key] && n == 3
                  changes[test_key] = ACTIVE
                end
              end
            end
          end
        end
      end
  
      # move changes into active
      # puts changes
      changes.each do |changed_key, state|
        if state
          active[changed_key] = ACTIVE
        else
          active.delete(changed_key)
        end
      end
    end

    active.keys.count
  end
end

path = 'input.txt'
day17 = Day17.new(path)

if ARGV.include?('--benchmark')
  Benchmark.bmbm do |x|
    x.report('part1') { day17.part1 }
    #x.report('part2') { day17.part2 }
  end
else
  puts day17.part1
  #puts day17.part2
end
