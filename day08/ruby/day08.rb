require 'pry'
require 'benchmark'

class Day08
  attr_accessor :accumulator, :offset, :instructions_executed, :code

  def initialize(path)
    @code = File.readlines(path).map(&:strip)
  end

  def execute_line(line)
    split = code[line].split(' ')
    instruction = split[0]
    arg = split[1]

    send(instruction.to_sym, arg.to_i)
    instructions_executed[line] = 1
  end

  def nop(_arg)
    # no op
    @offset += 1
  end

  def acc(arg)
    @accumulator += arg
    @offset += 1
  end

  def jmp(arg)
    @offset += arg
  end

  def part1
    reset
    while !instructions_executed.include?(offset)
      execute_line(offset)
    end
    accumulator
  end

  def part2
    iteration = 0
    code.find do |line|
      iteration += 1
      instruction = line.split(' ')[0]
      next if instruction == 'acc'
      reset

      line.gsub!(instruction, instruction == 'nop' ? 'jmp' : 'nop') # flip this operation
      while !instructions_executed.include?(offset) && @offset != code.size
        execute_line(offset)
      end
      line.gsub!(/nop|jmp/, instruction) # switch back
      offset == code.size
    end
    puts "iterations: #{iteration}"
    accumulator
  end

  def reset
    @accumulator = 0
    @instructions_executed = {}
    @offset = 0
  end
end

day08 = Day08.new('../input.txt')

puts day08.part1
puts day08.part2

if ARGV.include?('--benchmark')
  Benchmark.bmbm do |x|
    x.report('part1') { day08.part1 }
    x.report('part2') { day08.part2 }
  end
end
