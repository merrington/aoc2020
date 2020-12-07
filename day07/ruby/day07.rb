require 'pry'

CONTENTS_REGEX = /([0-9]*) ([\w ]*) bags?\.?/
class Day07
  attr_accessor :rules
  def initialize(path)
    @rules = {}
    File.readlines(path).each do |line|
      bag_types = line.split(' bags contain')
      bag_rule = bag_types[0].strip

      contents = if bag_types[1].strip == 'no other bags.'
        []
      else
        bag_types[1].split(',').map(&:strip).map do |contents|
          match = CONTENTS_REGEX.match(contents)
          {
            match[2] => match[1].to_i
          }
        end
      end

      @rules[bag_rule] = contents
    end
  end

  def part1(bag_color)
    # iterate over every rule to find who has 'bag_color'
    bag_types = rules.select do |bag, contents|
      contents.flat_map(&:keys).include?(bag_color)
    end.map { |rule| rule[0]}

    # loop over found bag colors
    # This should be cleaner because I'll probably end up with duplicates 🤷‍♂️
    bag_types.concat(bag_types.flat_map do |bag_type|
      a = part1(bag_type)
    end).uniq
  end

  def part2(bag_color)
    return 0 if rules[bag_color].empty?

    rules[bag_color].reduce(0) do |acc, bag_type|
      acc += (bag_type.values.first * part2(bag_type.keys.first)) + bag_type.values.first
    end
  end
end

puts Day07.new('../input.txt').part1('shiny gold').count
puts Day07.new('../input.txt').part2('shiny gold')
