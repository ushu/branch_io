require "httparty"
require "json"

# Submodules (hold the api method calls)
require_relative "client/links"

module BranchIO
  class Client
    class ErrorMissingBranchKey < StandardError; end

    # Submodules
    include Links

    # Include HTTParty for requests
    include HTTParty
    base_uri "https://api.branch.io"

    # Basic Api client
    attr_reader :branch_key, :branch_secret
    def initialize(branch_key = ENV["BRANCH_KEY"], branch_secret = ENV["BRANCH_SECRET"])
      @branch_key = branch_key
      @branch_secret = branch_secret

      unless branch_key
        raise ErrorMissingBranchKey, "No Branch Key found: please provided one such key to BranchIO::Client#initialize or by setting the BRANCH_KEY environment variable"
      end
    end

    def get(url)
      self.class.get(url, headers: default_headers)
    end

    def post(url, data = {})
      body = data.to_json
      self.class.post(url, body: body, headers: default_headers)
    end

    def put(url, data = {})
      body = data.to_json
      self.class.put(url, body: body, headers: default_headers)
    end

    def delete(url, data = {})
      body = data.to_json
      self.class.delete(url, body: body, headers: default_headers)
    end

    private

    def ensure_branch_secret_defined!
      unless branch_secret
        raise ErrorMissingBranchKey, "No Branch Secret found: please provided one such key to BranchIO::Client#initialize or by setting the BRANCH_SECRET environment variable"
      end
    end

    def default_headers
      {
        "Content-Type" => "application/json",
        "Accept" => "application/json"
      }
    end
  end
end
