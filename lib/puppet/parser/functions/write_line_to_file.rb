module Puppet::Parser::Functions
  newfunction(:write_line_to_file) do |args|
    filename = args[0]
    str = args[1]
    File.open(args[0], 'a') {|fd| fd.puts str }
    Puppet::Parser::Functions.autoloader.loadall
#    puts "hello world!"
    function_info(["hello world"])
  end
end

