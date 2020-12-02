require 'pry'

# rubocop:disable Metrics/MethodLength

class Day02
  WORKER_COUNT = 8

  def initialize
  end

  def go!(input_path)
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
