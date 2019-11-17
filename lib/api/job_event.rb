require_relative 'client'

module Api
  class JobEvent
    Mutation = Api::Client.parse <<-'GRAPHQL'
      mutation($input: CreateInput!) {
        jobEvent(input: $input) {
          errors
        }
      }
    GRAPHQL

    # TODO: this part is common between all mutations
    # most probably it can be extracted, so each mutation call
    # will just define query and arguments
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
            "event":  attributes[:event]
          }
        }
      }
    end
  end
end
