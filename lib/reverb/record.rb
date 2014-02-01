require 'json'

REDIS_LIST_KEY = 'reverb_records'

module Reverb
  class Record
    def initialize(raw_record)
      @raw_record = raw_record
    end

    def save
      puts 'ok'
    end

    def parse
      CSV.parse(@raw_record, {col_sep: separator,
                              converters: lambda { |x| x ? x.strip : nil }})
    end

    def to_h
      parsed = parse
      {
        last_name: parsed[0],
        first_name: parsed[1],
        sex: parsed[2],
        favorite_color: parsed[3],
        birthday: Date.parse(parsed[4]),
      }
    end

    def to_json
      JSON.dump(to_h)
    end

    def separator
      num_seps =  4
      if @raw_record.scan(/[^\\], /).length == num_seps
        return ','
      end
      if @raw_record.scan(/ \| /).length == num_seps
        return '|'
      end
      if @raw_record.scan(/[^\\] /).length == num_seps
        return ' '
      end
      raise "I cannot determine what the field separator is."
    end
  end
end
