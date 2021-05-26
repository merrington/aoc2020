require 'benchmark'
require 'pry'

class Day18
  attr_accessor :file, :path, :questions

  BRACKETS = /\((\d+( [\+\*] \d+)*)\)/
  ANY_OPERATION = /(\d+) ([\+\*]) (\d+)/
  ADDITION = /(\d+) (\+) (\d+)/
  MULTIPLICATION = /(\d+) (\*) (\d+)/

  def initialize(path)
    @path = path
    @file = File.open(path)
    @questions = file.readlines.map(&:strip)
  end

  def parse(expression)
    operand_stack = []
    operator_stack = []

    while (match = BRACKETS.match(expression))
      expression.sub!(BRACKETS, parse(match[1]).to_s)
    end

    last_char_type = nil
    expression.chars.each do |char|
      next if char == ' '

      case char
      when /[0-9]+/
        if last_char_type == 'operand'
          operand_stack.push((operand_stack.pop.to_s << char).to_i)
        else
          operand_stack.push(char.to_i)
        end
        last_char_type = 'operand'
      when /[\+\*]/ # only addition and multiplication it seems...
        operator_stack.push(char)
        last_char_type = 'operator'
      end
    end

    evaluate(operand_stack: operand_stack, operator_stack: operator_stack)
  end

  def evaluate(operand_stack:, operator_stack:)
    while operator_stack.size > 0
      operator = operator_stack.shift
      # every operation takes 2 values
      # handle first operand
      o1 = operand_stack.shift

      # handle second operand
      o2 = operand_stack.shift

      # solve and push to front of stack
      operand_stack.unshift(o1.send(operator.to_sym, o2))
    end
    operand_stack.shift
  end

  def parse_v2(expression, precedence = nil)
    expression = expression.clone

    while (match = BRACKETS.match(expression))
      expression.sub!(BRACKETS, parse_v2(match[1], precedence).to_s)
    end

    # no brackets left, LTR vs addition first
    if precedence.nil?
      while (match = ANY_OPERATION.match(expression))
        expression.sub!(ANY_OPERATION, evaluate_v2(match))
      end
    elsif precedence == '+'
      while (match = ADDITION.match(expression))
        expression.sub!(ADDITION, evaluate_v2(match))
      end
      while (match = MULTIPLICATION.match(expression))
        expression.sub!(MULTIPLICATION, evaluate_v2(match))
      end
    end
    expression.to_i
  end
  
  def evaluate_v2(match_data)
    match_data[1].to_i.send(match_data[2].to_sym, match_data[3].to_i).to_s
  end

  def part1
    questions.reduce(0) do |sum, question|
      # answer = parse(question)
      answer = parse_v2(question)
      sum + answer
    end
  end


  def part2
    questions.reduce(0) do |sum, question|
      answer = parse_v2(question, '+')
      sum + answer
    end
  end
end

path = 'input.txt'
day18 = Day18.new(path)

if ARGV.include?('--benchmark')
  Benchmark.bmbm do |x|
    x.report('part1') { day18.part1 }
    x.report('part2') { day18.part2 }
  end
else
  puts day18.part1
  puts day18.part2
end
