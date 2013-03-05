require 'json'

twers = []
File.open("twitternames.txt", "r").each_line do |line|
  unless line.start_with?("#") or line.strip == "" then
    twers.push(line.strip)
  end
end

followers = {}
twers.each do |username|
  response = JSON.parse(File.read("followers-#{username}.json"))
  response["ids"].each do |followerid|
    followers[followerid] = (followers[followerid] || 0) + 1
  end
end

total = 0
buckets = []
followers.each_value do |v|
  total += v
  buckets[v.to_i] = (buckets[v] || 0) + 1
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
  puts "  #{i}: #{v}" unless i == 0
end
