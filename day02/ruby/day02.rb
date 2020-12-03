require 'pry'

# rubocop:disable Metrics/MethodLength

class Day02
  WORKER_COUNT = 8

  def go!(input_path)
    #ractor(input_path)
    regular(input_path)
  end

  def ractor(input_path)
    pipe = Ractor.new do
      loop do
        Ractor.yield Ractor.recv
      end
    end

    workers = (1..WORKER_COUNT).map do
      Ractor.new pipe do |pipe|
        while line = pipe.take
          Ractor.yield(Line.new(line).valid_2?)
        end
      end
    end

    rows = 0
    read_file(input_path || '../input.txt').
      readlines.
      each do |line| 
        pipe << line
        rows += 1
      end

    (1..rows).select do |result|
      _r, valid = Ractor.select(*workers)
      valid
    end.size
  end

  def regular(input_path)
    read_file(input_path || '../input.txt').
      readlines.
      select { |line| Line.new(line).valid_2? }.
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
    #regex_line(line)
    manual_line(line)
  end

  def regex_line(line)
    parts = line.match(LINE_REGEX)

    @min = parts[1].to_i
    @max = parts[2].to_i
    @char = parts[3]
    @password = parts[4]
  end

  def manual_line(line)
    parts = line.split(' ')

    @min = parts[0].split('-')[0].to_i
    @max = parts[0].split('-')[1].to_i
    @char = parts[1][0]
    @password = parts[2]
  end

  def valid?
    count = password.chars.select { |pc| pc == char }.size
    min <= count && count <= max
  end

  def valid_2?
    (password[min-1] == char) ^ (password[max-1] == char)
  end
end

puts Day02.new.go!(ARGV[0])
