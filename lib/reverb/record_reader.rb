require 'csv'
require 'date'
require 'optparse'


module Reverb
  module RecordReader
    def self.run(args)
      options = getopts(args)
      filenames = args

      unless filenames.length > 0
        abort('feed me a stray filename')
      end

      display(sort(parse_files(filenames), options[:output]))
    end


    def self.getopts(args)
      options = {}
      OptionParser.new do |opts|
        opts.banner = "Usage: ./reverb --output [1..3] files"

        opts.on("-o", "--output [style]", Integer, "Style of output (options 1 to 3)") do |o|
          options[:output] = o
        end
      end.parse!(args)
      options
    end

    def self.sort(records, style)
      case style
      when 1
        ->(rs){ rs.sort_by { |r| [r[:sex], r[:last_name]] } }
      when 2
        ->(rs){ rs.sort_by { |r| r[:birthday] } }
      when 3
        ->(rs){ rs.sort_by { |r| r[:last_name] }.reverse }
      else
        abort("unrecognized output style: #{style}")
      end.call(records)
    end

    def self.display(records)
      records.each { |r|
        puts "#{r[:last_name]}, #{r[:first_name]}, #{r[:sex]}, #{r[:birthday].strftime('%m/%d/%Y')}, #{r[:favorite_color]}"
      }
    end

    def self.parse_files(filenames)
      filenames.collect_concat { |fname|
        parse_file(fname)
      }
    end

    def self.parse_file(filename)
      data = File.new(filename).read
      RecordParser.new(data).hashes
    end
  end
end
