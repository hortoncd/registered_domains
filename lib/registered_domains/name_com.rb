require 'json'
require 'httparty'

module RegisteredDomains
  module NameCom

    # Get the list of registered domains for an account from name.com
    # Returns an array of domain names.
    class Domains
      attr_reader :domains

      def initialize(user, api_key)
        @auth = {username: user, password: api_key}

        @domains = get
      end

      def get
        url = "https://api.name.com/v4/domains"
        response = HTTParty.get(url, basic_auth: @auth)
        response.success?
        resp = JSON.parse(response)

        # Handle some known error messages rather than falling through and getting NoMethodError for nils
        if resp.has_key?('message')
          if resp['message'] == 'Unauthenticated'
            raise "Failed to authenticate to #{url}"
          elsif resp['message'] == 'Permission Denied'
            raise "#{resp['message']}: #{resp['details']}"
          else
            raise resp['message']
          end
        end

        resp['domains'].map {|d| d['domainName']}
      end
    end
  end
end
