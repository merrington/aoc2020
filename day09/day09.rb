require 'benchmark'
require 'pry'

class Day09
  attr_accessor :stack, :input, :size

  def initialize(path, size)
    @input = File.open(path)
    @size = size
  end

  def read_line
    @input.readline.strip.to_i
  end

  def add_item(num)
    stack.shift
    stack.push(num)
  end

  def pair_exists?(num)
    sorted_stack = stack.dup.sort

    sorted_stack.each_with_index do |small, sm_index|
      big = 0
      big_index = sorted_stack.size - 1
      while small + big != num && big_index > sm_index
        big = sorted_stack[big_index]
        big_index -= 1
      end
      return true if small + big == num
    end

    false
  end

  def part1
    @part1 ||= begin
      @stack = Array.new(size)
      while !stack.first
        add_item(read_line)
      end

      loop do
        next_line = read_line
  
        break next_line unless pair_exists?(next_line)
        add_item(next_line)
      end
    end
  end

  def part2
    num_index = input.lineno # part 1 just ran, get the index
    input.rewind # reset the input

    # setup, at least 2 numbers
    @stack = Array.new(2)
    while !stack.first
      add_item(read_line)
    end

    while stack.reduce(&:+) != part1
      # add next number to stack
      stack.push(read_line)

      # check stack
      break if stack.reduce(&:+) == part1

      # pop numbers from front if too large
      while stack.reduce(&:+) > part1
        stack.shift
      end
    end

    stack.sort!
    stack.first + stack.last
  end
end

day09 = Day09.new('input.txt', 25)

puts day09.part1
puts day09.part2

if ARGV.include?('--benchmark')
  day09 = Day09.new('input.txt', 25)
  Benchmark.bmbm do |x|
    x.report('part1') { day09.part1 }
    x.report('part2') { day09.part2 }
  end
end
