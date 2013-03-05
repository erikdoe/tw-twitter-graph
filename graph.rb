require 'json'

idx = 1
twers = {}
File.open("twitternames.txt", "r").each_line do |line|
  unless line.start_with?("#") or line.strip == "" then
    twers[line.strip] = idx
    idx += 1
  end
end

followers = {}
twers.each_key do |username|
  response = JSON.parse(File.read("followers-#{username}.json"))
  response["ids"].each do |followerid|
    followers[followerid] ||= []
    followers[followerid].push(twers[username])
  end
end


puts "Creator \"graph.rb on #{Time.now.to_s}\""
puts "graph"
puts "["

twers.each { |username, id| puts "  node\n  [\n    id #{id}\n    label \"#{username}\"\n  ]" }
followers.each_key { |id| puts "  node\n  [\n    id #{id}\n    label \"\"\n  ]" }

followers.each do |followerid, followingids|
  followingids.each do | followingid |
    puts "  edge\n  [\n    source #{followerid}\n    target #{followingid}\n  ]"
  end
end

puts "]"
