require 'faraday'
require 'faraday_middleware'
require 'simple_oauth'
require 'json'

Dir[File.expand_path('../resources/*.rb', __FILE__)].each { |f| require f }
Dir[File.expand_path('../responses/*.rb', __FILE__)].each{ |f| require f }

module Fellowshipone
  class Client
    include Fellowshipone::Client::Communication
    include Fellowshipone::Client::Contribution
    include Fellowshipone::Client::Fund
    include Fellowshipone::Client::Household
    include Fellowshipone::Client::Person
    include Fellowshipone::Client::PledgeDrive

    attr_reader :church_code, :consumer_key, :consumer_secret, :token, :secret, :logger

    def initialize(church_code:, consumer_key:, consumer_secret:, token:, secret:, logger: false)
      @church_code     = church_code
      @consumer_key    = consumer_key
      @consumer_secret = consumer_secret
      @token           = token
      @secret          = secret
      @logger          = logger
    end

    def get(path, options = {})
      connection.get do |req|
        req.url(path, options)
      end.body
    end

    def get_raw(path, options = {})
      connection.get do |req|
        req.url(path, options)
      end
    end

    def post(path, req_body)
      connection.post do |req|
        req.url(path)
        req.body = req_body
      end.body
    end

    def put(path, req_body)
      connection.put do |req|
        req.url path
        req.body = req_body
      end
    end

    def delete(path, options = {})
      connection.delete do |req|
        req.url path
      end.body
    end

    def save
      connection.put do |req|
        req.url path
      end.body
    end

    private

    def connection
      Faraday.new(url: "https://#{church_code}.fellowshiponeapi.com", headers: { accept: 'application/json' }) do |connection|
        connection.request  :json
        connection.request  :oauth, oauth_data
        connection.response :logger if logger
        connection.response :mashify
        connection.response :json
        connection.use      :instrumentation
        connection.adapter  Faraday.default_adapter
      end
    end

    def oauth_data
      {
        consumer_key:    consumer_key,
        consumer_secret: consumer_secret,
        token:           token,
        token_secret:    secret
      }
    end
  end
end
