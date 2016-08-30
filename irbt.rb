# coding: utf-8
# An IRB + format_engine Test bed

require 'irb'

puts "Starting an IRB console with format_engine loaded."

if ARGV[0] == 'local'
  require_relative 'lib/format_engine'
  puts "format_engine loaded locally: #{FormatEngine::VERSION}"

  ARGV.shift
else
  require 'format_engine'
  puts "format_engine loaded from gem: #{FormatEngine::VERSION}"
end

IRB.start
