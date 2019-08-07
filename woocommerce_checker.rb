require 'sinatra'
require './lib/sinatra/woocommerce_api_helper'
require 'woocommerce_api'
require 'json'

get '/' do
  erb :index
end

post '/api' do
  WoocommerceAPI::Client.new({
    consumer_key: params[:key],
    consumer_secret: params[:secret],
    store_url: params[:site],
    mode: connection_mode(params[:site], params[:insecure_mode]),
    version: params[:api_version],
    wordpress_api: ["v1", "v2"].include?(params[:api_version]),
    headers: WoocommerceAPI::Client.default_client_options[:headers].merge({
      "User-Agent" => "TradeGeckoWoocommercePlayground/1.0 WoocommerceAPI/0.1.0"
    })
  })

  content_type :json

  begin
    if id = params[:object_id].presence
      resource = object_klass(params[:endpoint]).find(id)
      resource.save if params[:test_post]
      resource.to_json
    else
      object_klass(params[:endpoint]).all(per_page: params[:perpage]).to_json
    end
  rescue => e
    e.message
  end
end
