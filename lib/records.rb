require 'csv'

def main
  data_filename = ARGV[0]
  unless data_filename
    puts 'feed me a stray filename'
    exit
  end
  data = File.new(data_filename).read
  col_sep = guess_separator(data)
  display(format_data(data, col_sep))
end


def display(x)
  puts x.inspect
end

# Based on a fairly naive huristic, guess what the separator for the given data is
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
  CSV.parse(data, {col_sep: col_sep})
end

if __FILE__ == $0
  # ruby doesn't do this
  main()
end
