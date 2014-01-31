require 'csv'
require 'date'
require 'optparse'
require 'ostruct'


def main
  options = getopts()
  filenames = ARGV

  unless filenames.length > 0
    puts 'feed me a stray filename'
    exit
  end

  display(sort(construct_records(parse_files(filenames)), options.output))
end


def getopts
  options = OpenStruct.new
  OptionParser.new do |opts|
    opts.banner = "Usage: #{__FILE__} [options] files"

    opts.on("-o", "--output [style]", Integer, "Style of output") do |o|
      options.output = o
    end
  end.parse!
  options
end

def sort(records, style)
  case style
  when 1
    ->(rs){ rs.sort_by { |r| [r[:sex], r[:last_name]] } }
  when 2
    ->(rs){ rs.sort_by { |r| r[:birthday] } }
  when 3
    ->(rs){ rs.sort_by { |r| r[:last_name] }.reverse }
  end.call(records)
end

def display(records)
  records.each { |r|
    puts "#{r[:last_name]}, #{r[:first_name]}, #{r[:sex]}, #{r[:birthday].strftime('%m/%d/%Y')}, #{r[:favorite_color]}"
  }
end

def parse_files(filenames)
  filenames.collect_concat { |fname|
    parse_file(fname)
  }
end

def parse_file(filename)
  data = File.new(filename).read
  col_sep = guess_separator(data)
  CSV.parse(data, {col_sep: col_sep, converters: lambda { |x| x ? x.strip : nil}})
end

def construct_records(rows)
  rows.map { |row|
    {
      last_name: row[0],
      first_name: row[1],
      sex: row[2],
      favorite_color: row[3],
      birthday: Date.parse(row[4]),
    }
  }
end

# Based on a fairly naive huristic, guess what the separator for the given data is
# for now, depends on the fact that we're looking at 5 fields per entry
def guess_separator(data)
  # Dear code reviewer, start here!
  num_seps =  4 * data.split("\n").length
  if data.scan(/[^\\], /).length == num_seps
    return ','
  end
  if data.scan(/ \| /).length == num_seps
    return '|'
  end
  if data.scan(/[^\\] /).length == num_seps
    return ' '
  end
  raise "I can't tell what kind of file this is."
end

if __FILE__ == $0
  # ruby doesn't do this
  main()
end
