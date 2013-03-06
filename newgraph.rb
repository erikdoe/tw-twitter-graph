require 'json'
require 'narray'

idx = 0
twers = {}
File.open("twitternames.txt", "r").each_line do |line|
  unless line.start_with?("#") or line.strip == "" then
    twers[line.strip] = { :id => idx, :fcount => 0 }
    idx += 1
  end
end

followers = {}
twers.each_key do |username|
  next unless File.exists?("followers-#{username}.json")
  response = JSON.parse(File.read("followers-#{username}.json"))
  twers[username].merge!({ :fcount => response["ids"].length })
  response["ids"].each do |followerid|
    followers[followerid] ||= []
    followers[followerid].push(twers[username][:id])
  end
end

connections = NArray.int(twers.length, twers.length).fill!(0)
followers.each_value do |following|
  next if following.length < 2
  for i in (0 .. following.length-1)
    for j in (i+1 .. following.length-1)
      connections[following[i], following[j]] += 1
    end
  end
end

puts "Creator \"newgraph.rb on #{Time.now.to_s}\""
puts "graph"
puts "["

twers.each { |username, a| puts "  node\n  [\n    id #{a[:id]}\n    label \"#{username}\"\n    size #{a[:fcount]}\n  ]" }

for i in (0 .. twers.length-1)
  for j in (0 .. twers.length-1)
    cstrength = connections[i, j]
    if cstrength > 0 then
      puts "  edge\n  [\n    source #{i}\n    target #{j}\n    weight #{cstrength}\n  ]"
    end
  end
end

puts "]"

