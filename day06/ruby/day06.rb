require 'pry'

class Day06
  attr_accessor :input, :groups

  def initialize(path)
    @groups = File.readlines(path).reduce([{}]) do |acc, value|
      value.chomp!
      if value.empty?
        acc << {}
      else
        group = acc.pop
        value.chars.each do |char| 
          group[char] = (group[char] || 0) + 1
        end
        group[:people] = (group[:people] || 0) + 1
        acc << group
      end
    end
  end

  def part1
    groups.reduce(0) { |acc, group| acc += group.count - 1 }
  end

  def part2
    groups.reduce(0) do |acc, group|
      acc += group.reduce(0) do |acc, question| 
        if question[0] == :people
          acc
        else
          acc += question[1] == group[:count] ? 1 : 0
        end
      end
    end
  end
end

puts Day06.new('../input.txt').part1
puts Day06.new('../input.txt').part2
