require_relative '../client'

module Api
  module Scrapping
    class Failure
      Mutation = Api::Client.parse <<-'GRAPHQL'
        mutation($input: FailureInput!) {
          failedScrapping(input: $input) {
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
              "url":    attributes[:url],
              "exceptionClass": attributes[:exception].class.to_s,
              "message": attributes[:exception].message,
              "trace":   attributes[:exception].backtrace.join('\n')
            }
          }
        }
      end
    end
  end
end
