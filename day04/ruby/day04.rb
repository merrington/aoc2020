require 'pry'

class Day04
  # REQUIRED_FIELDS = %w[ byr iyr eyr hgt hcl ecl pid ].freeze
  REQUIRED_FIELDS = {
    byr: { min: 1920, max: 2002 },
    iyr: { min: 2010, max: 2020 },
    eyr: { min: 2020, max: 2030 },
    hgt: { min: 150, max: 193, regex: /([0-9]*)(cm|in)$/ },
    hcl: { regex: /\#[0-9a-f]{6}/ },
    ecl: { regex: /^(amb|blu|brn|gry|grn|hzl|oth){1}$/ },
    pid: { regex: /^[0-9]{9}$/ },
  }
  OPTIONAL_FIELDS = %w[ cid ]

  attr_accessor :batch, :passports

  def initialize(file_path)
    @batch = File.readlines(file_path)
    setup
  end

  def go!
    passports.select do |passport|  # valid?
      REQUIRED_FIELDS.reject do |field, rule|
        next false unless passport.keys.include? field.to_s

        passport_value = passport[field.to_s]
        rule_type = rule.keys.include?(:min) ? :limit : :regex
        case rule_type
        when :limit
          if field == :hgt
            match = passport_value.match(rule[:regex])
            next false unless match
            passport_value = match[2] == 'in' ? (match[1].to_i * 2.5423728814).round : match[1].to_i
          else
            passport_value = passport_value.to_i
          end
          passport_value >= rule[:min] && passport_value <= rule[:max]
        when :regex
          passport_value.match?(rule[:regex])
        end
      end.count == 0
    end.count
  end

  def setup
    @passports = batch.reduce([{}]) do |acc, line|
       if line[0] == "\n"
        acc << Hash.new
       else
        items = line.split(' ').map { |kvp| kvp.split(':') }.flatten
        new_item = acc.last.merge!(Hash[*items])
       end
       acc
    end
  end
end

puts Day04.new('../input.txt').go!
