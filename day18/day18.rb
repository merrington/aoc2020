require 'benchmark'
require 'pry'

class Day17
  attr_accessor :file, :path, :questions

  def initialize(path)
    @path = path
    @file = File.open(path)
    @questions = file.readlines.map(&:strip)
  end

  def parse(expression)
    operand_stack = []
    operator_stack = []

    expression.chars.each do |char|
      next if char == ' '

      case char
      when /[0-9]+/
        operand_stack.push(char.to_i)
      when /[\+\*]/ # only addition and multiplication it seems...
        operator_stack.push(char)
      when /[\(\)]/
        operand_stack.push(char)
      end
    end
    {
      operand_stack: operand_stack,
      operator_stack: operator_stack,
    }
  end

  def evaluate(operand_stack:, operator_stack:)
    while operator_stack.size > 0
      operator = operator_stack.shift
      # every operation takes 2 values

      # handle first operand
      o1 = operand_stack.shift
      if o1 == '('
        nested_eval = evaluate(operand_stack: operand_stack, operator_stack: operator_stack.unshift(operator))
        operand_stack = nested_eval[:operand_stack]
        operator_stack = nested_eval[:operator_stack]
        o1 = operand_stack.shift
        operator = operator_stack.shift
      end

      # handle second operand
      o2 = operand_stack.shift
      if o2 == ')'
        # this is the end of the current expression, return the operand
        return {
          operand_stack: operand_stack.unshift(o1), # these have been modified
          operator_stack: operator_stack.unshift(operator)
        }
      end

      if o2 == '('
        nested_eval = evaluate(operand_stack: operand_stack, operator_stack: operator_stack)
        operand_stack = nested_eval[:operand_stack]
        operator_stack = nested_eval[:operator_stack]
        o2 = operand_stack.shift
      end

      # solve and push to front of stack
      operand_stack.unshift(o1.send(operator.to_sym, o2))
    end
    {
      operand_stack: operand_stack,
      operator_stack: operator_stack
    }
  end

  def part1
    questions.reduce(0) do |sum, question|
      answer = evaluate(parse(question))[:operand_stack].first
      puts answer
      sum + answer
    end
  end


  def part2
    questions.reduce(0) do |sum, question|
      answer = evaluate(parse(question))[:operand_stack].first
      puts answer
      sum + answer
    end
  end
end

path = 'input.txt'
day17 = Day17.new(path)

if ARGV.include?('--benchmark')
  Benchmark.bmbm do |x|
    x.report('part1') { day17.part1 }
    #x.report('part2') { day17.part2 }
  end
else
  puts day17.part1
  puts day17.part2
end
