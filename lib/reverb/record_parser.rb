require 'csv'

module Reverb
  class RecordParser
    def initialize(raw_record)
      @raw_record = raw_record
      puts 'OK'
      puts raw_record
    end

    def parse
      CSV.parse(@raw_record, {col_sep: separator,
                              converters: lambda { |x| x ? x.strip : nil }})[0]
    end

    def to_h
      parsed = parse
      puts parsed.inspect
      {
        last_name: parsed[0],
        first_name: parsed[1],
        sex: parsed[2],
        favorite_color: parsed[3],
        birthday: Date.parse(parsed[4]),
      }
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
