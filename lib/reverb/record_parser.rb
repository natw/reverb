require 'csv'

module Reverb
  class RecordParser
    def initialize(raw_records)
      @raw_records = raw_records
    end

    def parse
      CSV.parse(@raw_records, {col_sep: separator,
                              converters: lambda { |x| x ? x.strip : nil }})
    end

    def hashes
      parse.collect { |r|
        {
          last_name: r[0],
          first_name: r[1],
          sex: r[2],
          favorite_color: r[3],
          birthday: Date.parse(r[4]),
        }
      }
    end

    def separator
      num_seps =  4 * @raw_records.split("\n").length
      if @raw_records.scan(/[^\\], /).length == num_seps
        return ','
      end
      if @raw_records.scan(/ \| /).length == num_seps
        return '|'
      end
      if @raw_records.scan(/[^\\] /).length == num_seps
        return ' '
      end
      raise "I cannot determine what the field separator is."
    end
  end
end
