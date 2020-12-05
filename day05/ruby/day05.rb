require 'pry'
class Day05
  attr_accessor :input

  def initialize(path)
    @input = File.readlines(path)
  end

  def call
    input.map do |seat|
      row = get_num(seat[0..6])
      aisle = get_num(seat[7..9])
      {
        row: row,
        aisle: aisle,
        id: (row * 8) + aisle
      }
    end
  end

  def get_num(pattern)
    num = 0
    pattern.reverse.chars.each_with_index do |char, index|
      num += 2**index if ['B', 'R'].include?(char)
    end
    num
  end
end

sorted = Day05.new('../input.txt').call.sort { |a, b| a[:id] <=> b[:id] }

# part 1
puts sorted.last[:id]

# part 2
sorted.each_with_index do |seat, index|
  next if index == 0 || index == sorted.size-1

  puts seat unless sorted[index-1][:id] == (seat[:id] - 1) && (sorted[index+1][:id] == (seat[:id] + 1))
end
