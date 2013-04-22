require 'json'
require 'narray'

load 'shared.rb'

def calc_connections(twers, followers)
  connections = NArray.int(twers.length, twers.length).fill!(0)
  followers.each_value do |following|
    next if following.length < 2 || following.length > 30
    for i in (0 .. following.length-1)
      for j in (i+1 .. following.length-1)
        connections[following[i], following[j]] += 1
      end
    end
  end
  connections
end


def write_graph(twers, connections)
  puts "Creator \"#{$0}\" on #{Time.now.to_s}"
  puts "graph"
  puts "["

  twers.each { |username, a| puts "  node\n  [\n    id #{a[:id]}\n    label \"#{username}\"\n    size #{a[:fcount]}.0\n  ]" }

  ec = 0
  for i in (0 .. twers.length-1)
    for j in (0 .. twers.length-1)
      if connections[i, j] > 4 then
        puts "  edge\n  [\n    source #{i}\n    target #{j}\n    weight #{connections[i, j]}\n  ]"
        ec += 1
      end
    end
  end
  $stderr.puts "#{ec} edges"

  puts "]"
end


twers = create_map(read_names())
connections = calc_connections(twers, read_followers(twers))
write_graph(twers, connections)
