require 'benchmark'
require 'pry'

class Day13
  attr_accessor :file, :timestamp, :bus_ids

  def initialize(path)
    @file = File.open(path)
    @timestamp = file.readline.strip.to_f
    @bus_ids = file.readline.split(',').
      each_with_index.
      reject { |bus_id, index| bus_id == 'x' }.
      map do |bus_id, index|
      {
        bus_id: bus_id.to_i,
        minute: index,
      }
      end
  end

  def part1
    next_bus = bus_ids.map do |bus|
      bus_id = bus[:bus_id]
      times = timestamp / bus_id
      {
        bus_id: bus_id,
        time: bus_id * times.ceil,
      }
    end.sort_by! { |item| item[:time] }.first

    minutes_waiting = next_bus[:time] - timestamp
    minutes_waiting * next_bus[:bus_id]
  end

  def part2
    factor = bus_ids.shift[:bus_id]
    time = factor
    bus_ids.each do |bus|
      # time + minutes later bus leaves needs to be a multiple of this bus id
      while 0 != ( time + bus[:minute] ) % bus[:bus_id]
        time += factor
      end
      # new factor needs to also be a multiple of this bus id
      factor *= bus[:bus_id]
    end

    time
  end
end

path = 'input.txt'
day13 = Day13.new(path)

if ARGV.include?('--benchmark')
  Benchmark.bmbm do |x|
    x.report('part1') { day13.part1 }
    x.report('part2') { day13.part2 }
  end
else
  puts day13.part1
  puts day13.part2
end


<<~COMMENT

t = 7x
t = 13y + 1
t = 59z + 4

COMMENT
