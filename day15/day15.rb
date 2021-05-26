require 'benchmark'
require 'pry'

class Day15
  attr_accessor :path, :file, :numbers, :spoken, :turn, :play_until
  # spoken = { num_spoken: [spoken_t, spoken_t2] }

  def initialize(path)
    @path = path
    @file = File.open(path)

    @spoken = {}
    @turn = 0
    @play_until = 2020
  end

  def read_starting_numbers
    @numbers = file.readline.split(',').map(&:to_i)
    numbers.each do |num|
      @turn += 1
      add_to_spoken(num)
    end
    numbers.last
  end
  
  def is_first_time_spoken?(num)
    spoken[num][:first] == nil
  end

  def add_to_spoken(num)
    spoken[num] = {
      first: spoken.dig(num, :last),
      last: turn,
    }
  end

  def play_next(num)
    @turn += 1
    if is_first_time_spoken?(num)
      add_to_spoken(0)
      0
    else
      next_num = spoken[num][:last] - spoken[num][:first]
      add_to_spoken(next_num)
      next_num
    end
  end

  def part1
    last_number = read_starting_numbers
    while (turn < play_until) do
      last_number = play_next(last_number)
    end
    last_number
  end

  def part2
    initialize(path)
    @play_until = 30000000
    part1
  end
end

path = 'sample.txt'
day15 = Day15.new(path)

if ARGV.include?('--benchmark')
  Benchmark.bmbm do |x|
    x.report('part1') { day15.part1 }
    x.report('part2') { day15.part2 }
  end
else
  puts day15.part1
  puts day15.part2
end
