require "branch_io/version"
require "branch_io/client"
require "branch_io/link_properties"

module BranchIO
  # Default client helper methods: delegate unknown calls to a new Client instance w/ default constructor params

  def self.method_missing(name, *args, &block)
    default_client = Client.new
    if default_client.respond_to?(name)
      default_client.send(name, *args, &block)
    else
      super
    end
  end

  def self.respond_to?(name)
    default_client = Client.new
    if default_client.respond_to?(name)
      return true
    end
    super
  end

end
