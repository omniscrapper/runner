require_relative '../client'

module Api
  module Scrapping
    class Success
      Mutation = Api::Client.parse <<-'GRAPHQL'
        mutation($input: SuccessInput!) {
          successfulScrapping(input: $input) {
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
              "taskId":   attributes[:task_id],
              "jobId":    attributes[:job_id],
              "url":      attributes[:url],
              "checksum": attributes[:checksum]
            }
          }
        }
      end
    end
  end
end
