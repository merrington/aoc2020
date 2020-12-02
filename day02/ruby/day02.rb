require 'pry'

class Day02
  def go!(input_path)
    file = read_file(input_path || '../input.txt')
    file.readlines.
      select { |line| Line.new(line).valid? }.
      size
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
end

puts Day02.new.go!(ARGV[0])
