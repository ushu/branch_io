require_relative "response"

module BranchIO
  class Client

    module Links
      LINK_PATH = "/v1/url"

      def link!(options={})
        res = link(options)
        res.validate!
        res
      end

      def link(options={})
        # Load and check the link properties
        link_properties = BranchIO::LinkProperties.wrap(options)

        # Build the request
        defaults = {
            sdk: :api,
            branch_key: self.branch_key
        }
        link_json = defaults.merge(link_properties.as_json)

        # Call branch.io public API
        raw_response = self.post(LINK_PATH, link_json)

        # Wrap the result in a Response
        if raw_response.success?
          UrlResponse.new(raw_response)
        else
          ErrorResponse.new(raw_response)
        end
      end

      def links!(options={})
        res = links(options)
        res.validate!
        res
      end

      def links(options=[])
        # Load and check the links properties
        link_properties_array = options.map{ |o| BranchIO::LinkProperties.wrap(o) }

        # Build the request
        links_url = "#{LINK_PATH}/bulk/#{self.branch_key}"
        links_json = link_properties_array.map(&:as_json)

        # Call branch.io public API
        raw_response = self.post(links_url, links_json)

        # Wrap the result in a Response
        if raw_response.success?
          BulkUrlsResponse.new(raw_response)
        else
          ErrorResponse.new(raw_response)
        end
      end

      def update_link!(options={})
        res = update_link(options)
        res.validate!
        res
      end

      def update_link(url, options={})
        ensure_branch_secret_defined!

        # Load and check the links configuration properties
        link_properties = BranchIO::LinkProperties.wrap(options)

        # Build the request URL
        encoded_url = URI.encode_www_form_component(url)
        update_url = "#{LINK_PATH}?url=#{encoded_url}"

        # Build the request body
        defaults = {
            sdk: :api,
            branch_key: self.branch_key,
            branch_secret: self.branch_secret
        }
        update_json = defaults.merge(link_properties.as_json)

        # Call branch.io public API
        raw_response = self.put(update_url, update_json)

        # Wrap the result in a Response
        if raw_response.success?
          LinkPropertiesResponse.new(raw_response)
        else
          ErrorResponse.new(raw_response)
        end
      end

      def link_info!(options={})
        res = link_info(options)
        res.validate!
        res
      end

      def link_info(url)
        # Build the request URL
        encoded_url = URI.encode_www_form_component(url)
        encoded_key = URI.encode_www_form_component(branch_key)
        show_url = "#{LINK_PATH}?url=#{encoded_url}&branch_key=#{encoded_key}"

        # Call branch.io public API
        raw_response = self.get(show_url)

        # Wrap the result in a Response
        if raw_response.success?
          LinkPropertiesResponse.new(raw_response)
        else
          ErrorResponse.new(raw_response)
        end
      end

    end

  end
end
