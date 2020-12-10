require 'benchmark'
require 'pry'

class Day10
  CACHE = {}
  DEVICE = 'device'.freeze

  attr_accessor :adapter_joltages, :joltage_jumps

  def initialize(path)
    @adapter_joltages = File.readlines(path).map(&:to_i).sort
    @joltage_jumps = {
      0 => [],
      1 => [],
      2 => [],
      3 => [],
    }
  end

  def part1
    adapter_joltages.each_with_index do |adapter_joltage, index|
      if index + 1 == adapter_joltages.size
        joltage_jumps[1] << index
        joltage_jumps[3] << DEVICE
      else
        # binding.pry
        diff = adapter_joltages[index + 1] - adapter_joltage
        joltage_jumps[diff] << index
      end
    end

    joltage_jumps[1].count * joltage_jumps[3].count
  end

  def part2
    # Starting number
    device = adapter_joltages.last + 3

    _part2(device)
  end

  def _part2(joltage)
    CACHE[joltage] ||= begin
      default_accumulator = 0

      # base case - we can get to the outlet (+1), but still might need to check -1, -2
      if [1,2,3].include?(joltage)
        default_accumulator = 1
      end

      # check if we have adapters for joltages of -1, -2, -3
      [1, 2, 3].reduce(default_accumulator) do |accumulator, offset|
        if index = adapter_joltages.find_index(joltage - offset)
          accumulator += _part2(adapter_joltages[index])
        else
          accumulator
        end
      end
    end
  end
end

path = 'input.txt'
day10 = Day10.new(path)

if ARGV.include?('--benchmark')
  Benchmark.bmbm do |x|
    x.report('part1') { day10.part1 }
    x.report('part2') { day10.part2 }
  end
else
  puts day10.part1
  puts day10.part2
end
