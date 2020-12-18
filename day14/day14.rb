require 'benchmark'
require 'pry'

class Day14
  attr_accessor :file, :bitmask, :memory

  def initialize(path)
    @file = File.open(path)
    @memory = {}
  end

  def readline
    return if file.eof?

    line = file.readline.split(' = ')
    case line[0]
    when 'mask'
      @bitmask = line[1].strip
    else
      num = line[1].to_i.to_s(2).reverse
      value = bitmask.reverse.chars.each_with_index.reduce(0) do |acc, mask|
        mask_char = mask[0]
        mask_index = mask[1]
        next_bit = (mask_char == 'X' ? (num[mask_index] || 0) : mask_char).to_i
        acc += next_bit * (2 ** mask_index)
      end

      address = line[0][4..-2].to_i
      @memory[address] = value
    end
  end

  def part1
    while readline do end
    @memory.values.reduce(&:+)
  end

  def binary_string_to_integer(binary)
    binary.chars.reverse.each_with_index.reduce(0) do |acc, char_with_index|
      acc += char_with_index[0].to_i * (2 ** char_with_index[1])
    end
  end

  def readline_part2
    return if file.eof?

    line = file.readline.split(' = ')
    case line[0]
    when 'mask'
      @bitmask = line[1].strip
    else
      num = line[1].to_i

      starting_address = line[0][4..-2].to_i.to_s(2).reverse
      address = bitmask.reverse.chars.each_with_index.map do |char, index|
        case char
        when '0'
          starting_address[index] || '0'
        when '1'
          '1'
        else
          ['0','1']
        end
      end
      
      addresses = address.reverse.reduce(['']) do |acc, char|
        if char.is_a?(Array)
         acc.map { |addr| [addr.dup << '0', addr.dup << '1'] }.flatten
        else
         acc.map { |addr| addr << char }
        end
      end.each do |address|
        address_int = binary_string_to_integer(address)
        @memory[address_int] = num
      end
    end
  end

  def part2
    file.rewind
    @memory = {}
    while readline_part2 do end
    memory.values.reduce(&:+)
  end
end

path = 'input.txt'
day14 = Day14.new(path)

if ARGV.include?('--benchmark')
  Benchmark.bmbm do |x|
    x.report('part1') { day14.part1 }
    x.report('part2') { day14.part2 }
  end
else
  puts day14.part1
  puts day14.part2
end
