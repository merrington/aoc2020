require 'pry'

# rubocop:disable Metrics/MethodLength

class Day02
  def go!(input_path)
    ractors = read_file(input_path || '../input.txt').
      readlines.
      map do |line| 
        Ractor.new(line) do |line|
          Line.new(line).valid_2?
        end
      end

    valid_count = 0
    until ractors.empty?
      ractor, valid = Ractor.select(*ractors)
      ractors.delete ractor
      valid_count += 1 if valid
    end
    valid_count
  end

  def read_file(path)
    File.open(path)
  end
end

class Line
  attr_accessor :min, :max, :char, :password

  LINE_REGEX = /([0-9]*)-([0-9]*) ([a-zA-Z]): (\w*)/.freeze

  def initialize(line)
    line = line.match(LINE_REGEX)

    @min = line[1].to_i
    @max = line[2].to_i
    @char = line[3]
    @password = line[4]
  end

  def valid?
    count = password.chars.select { |pc| pc == char }.size
    min <= count && count <= max
  end

  def valid_2?
    valid = false
    password.chars.each_with_index do |pc, index|
      valid = !valid if (index + 1 == min || index + 1 == max) && pc == char
    end
    valid
  end
end

puts Day02.new.go!(ARGV[0])
