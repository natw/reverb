require 'csv'

def main
  data_file = ARGV[0]
  data = File.new(data_file).read
  col_sep = determine_separator(data)
  display(format_data(data, col_sep))
end


def display(x)
  puts x.inspect
end

def determine_separator(data)
  ','
end

def format_data(data, col_sep)
  CSV.parse(data, {col_sep: col_sep})
end

main()
