class ScoutScout::Descriptor < Hashie::Mash
  attr_accessor :server, :plugin

  # Search for descriptors by matching name and hostname.
  #
  # Options:
  #
  # - :descriptor => The descriptor name to match
  # - :host => The host name to match
  #
  # @return [Array] An array of ScoutScout::Descriptor objects
  def self.all(options = {})
    response = ScoutScout.get("/#{ScoutScout.account}/descriptors.xml?descriptor=#{CGI.escape(options[:descriptor] || String.new)}&host=#{options[:host]}")
    response['ar_descriptors'] ? response['ar_descriptors'].map { |descriptor| ScoutScout::Descriptor.new(descriptor) } : Array.new
  end

  # @return [ScoutScout::Metric]
  def average(opts = {})
    ScoutScout::Cluster.average(name, options_for_relationship(opts))
  end

  # @return [ScoutScout::Metric]
  def maximum(opts = {})
    ScoutScout::Cluster.maximum(name, options_for_relationship(opts))
  end

  # @return [ScoutScout::Metric]
  def minimum(opts = {})
    ScoutScout::Cluster.minimum(name, options_for_relationship(opts))
  end

protected

  def options_for_relationship(opts = {})
    relationship_options = {}
    relationship_options[:host] = server.hostname if server
    opts.merge(relationship_options)
  end

end
