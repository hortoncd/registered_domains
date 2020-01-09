require 'httparty'
require 'namecheap_api'
require 'rexml/document'

module RegisteredDomains
  module Namecheap

    # Get the list of registered domains for an account from namecheap
    # Returns an array of domain names.
    class Domains
      attr_reader :domains

      def initialize(user, api_key, api_user)
        ip = ::HTTParty.get('https://ipv4.icanhazip.com')
        ip.success?
        @config = {
          client_ip: ip,
          username: user,
          api_key: api_key,
          api_username: api_user,
        }

        @page_size = 100
        @total_items = 0
        @domains = []
        get
      end

      def client
        @client ||= NamecheapApi::Client.new(@config)
      end

      def send_request(page_size, page)
        client.call('namecheap.domains.getList', {PageSize: @page_size, Page: page})
      end

      def doc
        REXML::Document.new @response.raw_body
      end

      def get_total_items
        doc.elements.each("ApiResponse/CommandResponse/Paging/TotalItems") { |element| @total_items = element.text.to_i }
      end

      def extract_domains
        domains = []
        doc.elements.each("ApiResponse/CommandResponse/DomainGetListResult/Domain") { |element| domains << element.attributes['Name'] }
        domains
      end

      def get
        # value for total domains for initial request.  actual value determined from first response
        @total_items = @page_size

        page = 0
        requested_items = 0
        while requested_items < @total_items
          # Initial request, from which we'll determine if we need to keep requesting more pages
          requested_items += @page_size
          page += 1
          @response = send_request(@page_size, page)
          response_ok?
          get_total_items
          @domains += extract_domains
        end
      end

      def response_ok?
        doc.elements.each("ApiResponse") { |element| @response_status = element.attributes['Status'] }
        if @response_status == 'OK'
          return true
        else
          @errors = []
          doc.elements.each("ApiResponse/Errors/Error") { |element| @errors << element.text }
          raise @errors.join(':').to_s
        end
      end
    end
  end
end
