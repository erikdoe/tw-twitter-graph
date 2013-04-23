require 'json'
require 'gexf'

load 'shared.rb'


def write_graph(twers, followers)
  graph = GEXF::Graph.new(:defaultedgetype => GEXF::Edge::DIRECTED)
  graph.define_node_attribute(:name)
  graph.define_node_attribute(:followers, :type => GEXF::Attribute::INTEGER, :default => 0)
  graph.define_node_attribute(:tweets, :type => GEXF::Attribute::INTEGER, :default => 0)

  followers.each_key do |id| 
    graph.create_node(:id => id, :label => "")
  end

  twers.each do |username, a| 
    n = graph.create_node(:id => a[:id], :label => username)
    n[:name] = a[:name]
    n[:followers] = a[:fcount].to_i
    n[:tweets] = a[:tcount].to_i
  end

  followers.each do |followerid, followingids|
    followingids.each do | followingid |
      graph.create_edge(graph.nodes[followerid.to_s], graph.nodes[followingid.to_s])
    end
  end

  puts graph.to_xml
end


twers = create_map(read_names())
followers = read_followers(twers, :id)
write_graph(twers, followers)
