require 'pry'

INPUT_FILE = './input.txt'
PREVIOUS_NUMBERS = []

def get_input(path: INPUT_FILE)
  File.open(path)
end

numbers = get_input.
  readlines.
  map(&:to_i).
  sort

numbers.each_with_index do |small, sm_index|
  big = 0
  big_index = numbers.size - 1
  med = 0
  med_index = 0
  while small + med + big != 2020 && big_index > med_index
    med = 0
    med_index = big_index - 1
    while small + med + big != 2020 && med_index > sm_index
      med = numbers[med_index]
      med_index -= 1
    end
    big = numbers[big_index]
    big_index -= 1
  end
  puts small * med * big if small + med + big == 2020
end
