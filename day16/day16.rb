require 'benchmark'
require 'pry'

class Day16
  attr_accessor :file, :path, :rules, :ticket, :nearby_tickets

  def initialize(path)
    @path = path
    @file = File.open(path)
    @rules = {}

    # read the rules
    while (line = file.gets.strip) != ''
      rule = line.split(': ')
      rule_name = rule[0]
      rules[rule_name] = []

      rule_ranges = rule[1].split(' or ')
      rule_ranges.map { |r| r.split('-') }.each do |range|
        rules[rule_name].push({
          min: range[0].to_i,
          max: range[1].to_i,
        })
      end
    end

    # read your ticket
    while (line = file.gets.strip) != ''
      next if line == 'your ticket:'
      @ticket = line.split(',').map(&:to_i)
    end

    # read nearby tickets
    @nearby_tickets = []
    while (line = file.gets&.strip)
      next if line == 'nearby tickets:'
      nearby_tickets.push(line.split(',').map(&:to_i))
    end
  end

  def valid_in_rule?(field_value, rule)
    rule.reduce(false) do |valid, limits|
      valid = true if field_value >= limits[:min] && field_value <= limits[:max]
      valid
    end
  end

  def part1
    nearby_tickets.reduce(0) do |error_rate, ticket|
      ticket.reduce(error_rate) do |error_rate, field|
        valid = rules.values.find do |rule|
          valid_in_rule?(field, rule)
        end

        error_rate += field unless valid
        error_rate
      end
    end
  end

  def part2
    answer = 1
    valid_tickets = nearby_tickets.select do |ticket_fields|
      # return false when any field is invalid
      ticket_fields.reduce(true) do |valid, field|
        valid && rules.values.reduce(false) do |field_valid, rule|
          field_valid || valid_in_rule?(field, rule)
        end
      end
    end

    field_mapping = {}
    field_count = ticket.size

    while (field_mapping.size < field_count)
      # iterate over every nth field, test for each rule and reject when a rule fails
      (0..field_count - 1).each do |field_num|
        # skip if this field has been assigned
        next if field_mapping.values.include?(field_num)
        # find all rules that every value of current field is valid for
        passable_rules = rules.select do |name, rule|
          valid_tickets.reduce(true) do |rule_valid, ticket|
            rule_valid && valid_in_rule?(ticket[field_num], rule)
          end
        end

        # if there's only one possible option...
        if passable_rules.count == 1
          rule = passable_rules.first
          field_mapping[rule[0]] = field_num
          rules.delete(rule[0])
          puts "#{field_num} => #{rule[0]}"

          answer *= ticket[field_num] if (rule[0].start_with?('departure'))
        end
      end
    end
    puts field_mapping
    answer
  end
end

path = 'input.txt'
day16 = Day16.new(path)

if ARGV.include?('--benchmark')
  Benchmark.bmbm do |x|
    x.report('part1') { day16.part1 }
    x.report('part2') { day16.part2 }
  end
else
  puts day16.part1
  puts day16.part2
end
