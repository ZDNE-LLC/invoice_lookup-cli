require 'graphql/client'
require 'graphql/client/http'

class GraphqlClient
  attr_reader :client
  token =  ENV['GRAPHQL_TOKEN']
  endpoint = "https://bills.zdnenterprises.com/graphql?token=#{token}"
  HTTP = GraphQL::Client::HTTP.new(endpoint)
  Schema = GraphQL::Client.load_schema(HTTP)

  def initialize
    @client = GraphQL::Client.new(schema: Schema, execute: HTTP)
  end
end
