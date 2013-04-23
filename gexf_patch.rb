class GEXF::Edge
    def to_hash
    optional = {}
    optional[:label] = label if label && !label.empty?
    optional[:weight] = weight if weight

    {:id => id,
     :source => source_id,
     :target => target_id,
     :type => type

    }.merge(optional)
  end
end
