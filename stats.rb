require 'json'

load 'shared.rb'

twers = create_map(read_names())
followers = read_followers(twers)

total = 0
buckets = []
followers.each_value do |v|
  total += v.length
  buckets[v.length] = (buckets[v.length] || 0) + 1
end

puts "ThoughtWorkers: #{twers.length}"
puts "The number of Twitter Ids the results are based on.\n\n"

puts "Total followers: #{total}"
puts "The number of followers for each ThoughtWorker added up.\n\n"

puts "Unique followers: #{followers.length}"
puts "The number of people who follow one or more ThoughtWorkers.\n\n"

puts "Connectedness:"
puts "The number of people who follow *x* ThoughtWorkers."
buckets.each_with_index do |v, i|
  puts "  #{v} => #{i}" unless v.nil?
end
