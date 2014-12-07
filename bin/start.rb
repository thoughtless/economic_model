#!/usr/bin/env ruby

require_relative "../lib/economic_model/world"

world = EconomicModel::World.new
puts "="*80
puts "Started world #{world.object_id}"
puts "="*80

puts world.status

@input = nil
def get_input
  print "\nWhat next? (c for continue; q for quit) "
  @input = gets.chomp
end

get_input
while @input != "q"
  if @input == "c"
    world.continue
    puts world.status
  else
    puts "Unexpected input #{@input.inspect}. Please type 'c' or 'q'."
  end
  get_input
end

puts "Good bye"


