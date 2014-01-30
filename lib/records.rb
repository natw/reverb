require 'csv'

def main
  filenames = ARGV
  unless filenames.length > 0
    puts 'feed me a stray filename'
    exit
  end
  filenames.each { |filename|
    data = File.new(filename).read
    col_sep = guess_separator(data)
    display(format_data(data, col_sep))
  }
end


def display(x)
  puts x.inspect
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

def format_data(data, col_sep)
  CSV.parse(data, {col_sep: col_sep, converters: lambda { |x| x ? x.strip : nil}})
end

if __FILE__ == $0
  # ruby doesn't do this
  main()
end
