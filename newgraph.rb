require 'json'
require 'narray'

load 'shared.rb'

def calc_connections(twers, followers)
  connections = NArray.int(twers.length, twers.length).fill!(0)
  followers.each_value do |following|
    next if following.length < 2
    for i in (0 .. following.length-1)
      for j in (i+1 .. following.length-1)
        connections[following[i], following[j]] += 1
      end
    end
  end
  connections
end


def write_graph(twers, connections)
  puts "Creator \"newgraph.rb on #{Time.now.to_s}\""
  puts "graph"
  puts "["

  twers.each { |username, a| puts "  node\n  [\n    id #{a[:id]}\n    label \"#{username}\"\n    size #{a[:fcount]}\n  ]" }

  for i in (0 .. twers.length-1)
    for j in (0 .. twers.length-1)
      if connections[i, j] > 2 then
        puts "  edge\n  [\n    source #{i}\n    target #{j}\n    weight #{connections[i, j]}\n  ]"
      end
    end
  end

  puts "]"
end


twers = create_map(read_names())
connections = calc_connections(twers, read_followers(twers))
write_graph(twers, connections)
