module BranchIO
  class LinkProperties
    attr_reader :tags
    attr_reader :channel
    attr_reader :feature
    attr_reader :campaign
    attr_reader :stage
    attr_reader :alias
    attr_reader :type
    attr_reader :duration
    attr_reader :data

    def self.wrap(options)
      if options.kind_of?(LinkProperties)
        options
      else
        new(options)
      end
    end

    def initialize(options = {})
      @tags     = options.delete(:tags) || options.delete("tags")
      @channel  = options.delete(:channel)  || options.delete("channel")
      @feature  = options.delete(:feature)  || options.delete("feature")
      @campaign = options.delete(:campaign) || options.delete("campaign")
      @stage    = options.delete(:stage)    || options.delete("stage")
      @alias    = options.delete(:alias)    || options.delete("alias")
      @type     = options.delete(:type)     || options.delete("type")
      @duration     = options.delete(:duration)     || options.delete("duration")
      @data     = options.delete(:data)     || options.delete("data")

      unless options.empty?
        raise ErrorInvalidParameters, options.keys
      end
    end

    def as_json
      json = {}
      json[:tags]     = tags if tags
      json[:channel]  = channel if channel
      json[:feature]  = feature if feature
      json[:campaign] = campaign if campaign
      json[:stage]    = stage if stage
      json[:alias]    = self.alias if self.alias
      json[:type]     = type if type
      json[:duration] = duration if duration
      json[:data]     = data if data
      json
    end

    class ErrorInvalidParameters < StandardError
      attr_reader :parameters
      def initialize(parameters)
        @parameters = parameters
        super("Invalid parameters for BranchIO::LinkProperties: \"#{@parameters.join(', ')}\"")
      end
    end
  end
end
