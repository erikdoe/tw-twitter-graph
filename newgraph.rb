require 'json'
require 'narray'
require 'gexf'

load 'gexf_patch.rb'
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
  graph = GEXF::Graph.new
  graph.define_node_attribute(:id)
  graph.define_node_attribute(:name)
  graph.define_node_attribute(:followers, :type => GEXF::Attribute::INTEGER)
  graph.define_node_attribute(:tweets, :type => GEXF::Attribute::INTEGER)

  twers.each do |username, a| 
    n = graph.create_node(:id => a[:idx].to_i, :label => username)
    n[:id] = a[:id]
    n[:name] = a[:name]
    n[:followers] = a[:fcount].to_i
    n[:tweets] = a[:tcount].to_i
  end

  for i in (0 .. twers.length-1)
    for j in (0 .. twers.length-1)
      if connections[i, j] > 4 then
        e = graph.create_edge(graph.nodes[i.to_s], graph.nodes[j.to_s], :weight => connections[i, j])
      end
    end
  end
  
  $stderr.puts "#{graph.edges.count} edges"
  puts graph.to_xml
end


twers = create_map(read_names())
connections = calc_connections(twers, read_followers(twers))
write_graph(twers, connections)
