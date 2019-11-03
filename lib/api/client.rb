require "graphql/client"
require "graphql/client/http"

module Api
  HTTP = GraphQL::Client::HTTP.new(ENV['API_URL'])
  # Fetch latest schema on init, this will make a network request
  Schema = GraphQL::Client.load_schema(HTTP)
  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end
