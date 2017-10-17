module BranchIO
  class Client
    class ErrorApiCallFailed < StandardError
      attr_reader :response
      def initialize(response)
        @response = response
        super("API call failed")
      end
    end

    class Response
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def request
        response.request
      end

      def success?
        response.success?
      end

      def failure?
        !success?
      end

      def validate!
        raise ErrorApiCallFailed, self unless success?
      end

      def json
        response.parsed_response
      end
    end

    class UrlResponse < Response
      def success?
        true
      end

      def url
        json["url"]
      end
    end

    class ErrorResponse < Response
      def success?
        false
      end

      def code
        json["code"]
      end

      def error
        json["error"]
      end
    end

    class BulkUrlsResponse < Response
      def success?
        responses.all?(&:success?)
      end

      def urls
        successful_responses.map(&:url)
      end

      def errors
        erroneous_responses.map(&:error)
      end

      def successful_responses
        responses.select(&:success?)
      end

      def erroneous_responses
        responses.reject(&:success?)
      end

      def responses
        @responses ||= json.map do |url_info|
          # below the EmbeddedResponseWrapper(s) act as a dummp HTTParty response
          if url_info.key?("error")
            ErrorResponse.new(EmbeddedResponseWrapper.new(url_info))
          else
            UrlResponse.new(EmbeddedResponseWrapper.new(url_info))
          end
        end
      end

      # rubocop: disable Lint/UselessAccessModifier
      # Not sure why RuboCop thinks this is useless.

      private

      # rubocop: enable Lint/UselessAccessModifier

      EmbeddedResponseWrapper = Struct.new(:parsed_response)
    end

    class LinkPropertiesResponse < Response
      def link_properties
        @link_properties ||= BranchIO::LinkProperties.new(json)
      end
    end
  end
end
