require 'sinatra/base'

module Sinatra
  module WoocommerceApiHelper
    def object_klass(endpoint)
      "WoocommerceAPI::#{endpoint.capitalize}".safe_constantize
    end

    def connection_mode(site, insecure_mode)
      case site
      when /http:\/\//
        :oauth_http
      else
        if insecure_mode
          :query_https
        else
          :oauth_https
        end
      end
    end
  end

  helpers WoocommerceApiHelper
end
