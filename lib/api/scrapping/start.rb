require_relative '../client'

module Api
  module Scrapping
    class Start
      Mutation = Api::Client.parse <<-'GRAPHQL'
        mutation($input: StartInput!) {
          startedScrapping(input: $input) {
            errors
          }
        }
      GRAPHQL

      def call(attributes = {})
        Api::Client.query(Mutation, variables: to_variables(attributes))
      end

      private

      def to_variables(attributes)
        {
          "input": {
            "attributes": {
              "taskId": attributes[:task_id],
              "jobId":  attributes[:job_id],
              "url":    attributes[:url]
            }
          }
        }
      end
    end
  end
end
