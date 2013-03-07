require 'json'

load 'shared.rb'


def write_graph(twers, followers)
  puts "Creator \"graph.rb on #{Time.now.to_s}\""
  puts "graph"
  puts "["

  twers.each { |username, a| puts "  node\n  [\n    id #{a[:id]}\n    label \"#{username}\"\n    size #{a[:fcount]}\n  ]" }
  followers.each_key { |id| puts "  node\n  [\n    id #{id}\n    label \"\"\n    size 1\n  ]" }

  followers.each do |followerid, followingids|
    followingids.each do | followingid |
      puts "  edge\n  [\n    source #{followerid}\n    target #{followingid}\n  ]"
    end
  end

  puts "]"
end


twers = create_map(read_names())
followers = read_followers(twers)
write_graph(twers, followers)
