require 'uri'
require 'json'
require 'rest-client'

module MailgunAggregation
  class Client
    MAILGUN_API_HOST = 'api.mailgun.net'
    MAILGUN_API_VERSION = 'v3'

    attr_accessor :auth_key

    def initialize(api_key, domain_name)
      @auth_key = "api:#{api_key}"
      @base_url = "https://#{MAILGUN_API_HOST}/#{MAILGUN_API_VERSION}/#{domain_name}"
    end

    def run
      v = "#{@base_url}/events"
      loop do
        v = recursive_connection v
        break unless v
      end
    end

    def recursive_connection(url)
      beginning = url
      uri = URI url
      response = RestClient.get "#{uri.scheme}://#{self.auth_key}@#{uri.host}#{uri.path}"
      payload = JSON.parse response.body

      output_logs payload['items']

      paging = payload['paging']
      next_page = paging['next']
      if beginning == next_page
        return false
      else
        return next_page
      end
    end

    def output_logs(data)
      File.open("logs/out.log", "a") do |f|
        f.puts data.to_json
      end
    end
  end
end
