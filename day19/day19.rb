require 'benchmark'
require 'pry'

class Day19
  attr_accessor :file, :path, :rules, :messages, :trie
  STRING = 'string'.freeze
  POINTER = 'pointer'.freeze

  def initialize(path)
    @path = path
    @file = File.open(path)
    @rules = {}
    @messages = []
    @trie = {}

    while (line = file.readline.strip) != ''
      line_split = line.split(': ')
      key = line_split[0].to_i
      if line_split[1].include?('"')
        # string rule
        rules[key] = {
          type: STRING,
          rule: line_split[1][1]
        }
      else
        # pointer
        options = line_split[1].
          split(' | ').
          reduce([]) do |options, option|
            options << option.split(' ').map(&:to_i)
          end
        rules[key] = {
          type: POINTER,
          rule: options,
        }
      end
    end

    trie['root'] = {
      children: {},
      terminal: false,
    }
    binding.pry
    add_child(rules[0].first, trie['root'])

    pp trie
    messages = file.readlines.map(&:strip)
  end

  def resolve_rule(chain)
    rule_num = chain.shift
    rule = rules[rule_num]
    return [rule[:rule], *chain] if rule[:type] == STRING
    # [[1, 1], [2, 2]]
    # [[1]]
    rule[:rule].map do |rule_option|
      head, *tail = rule_option
      #resolve_rule(head, tail.concat(chain))
      resolve_rule(rule_option.concat(chain))
    end
  end

  def add_child(chain, parent)
    resolved = resolve_rule(chain)
    # resolved 
  end

  def add_child(rule_chain, parent)
    # get the first rule, resolve to strings
    pp trie
    rule_chain.each do |rule_option|
      # binding.pry
      current = rule_option.shift
      puts "Adding #{current}, left #{rule_option}"
      find_leaves(current).map do |letter|
        child = {
          children: {},
        }
        parent[:children][letter] = child
        if rule_option.empty?
          child[:terminal] = true
        else
          # pass the remaining ruleset down with the new child as the parent
          add_child([rule_option], child)
          # binding.pry
        end
      end
    end
  end

  def find_leaves(rule_key)
    # binding.pry
    rule = rules[rule_key]
    return rule[:rule] if rule[:type] == STRING
    # if it's not a string, build up a list of of the rule validations that need to happen
    binding.pry

    rule[:rule].map do |results, option| 
      map = option.map do |option_node|
        find_leaves(option_node).map { |leaves| leaves }
      end
      map
    end
  end

  def part1
    messages.reduce(0) do |count, message|
    end
  end


  def part2
  end
end

path = 'sample.txt'
day19 = Day19.new(path)

if ARGV.include?('--benchmark')
  Benchmark.bmbm do |x|
    x.report('part1') { day19.part1 }
    x.report('part2') { day19.part2 }
  end
else
  puts day19.part1
  puts day19.part2
end
