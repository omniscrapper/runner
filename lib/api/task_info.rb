require_relative 'client'

module Api
  class TaskInfo
    Query = Api::Client.parse <<-'GRAPHQL'
      query($id: ID!) {
        task(id: $id) {
          id
          crawler
          site {
            id
            name
            url
          }
          schema {
            id
            name
            definition
          }
          crawlerParams
          scrapperParams
        }
      }
    GRAPHQL

    def call(task_id:)
      result = Api::Client.query(Query, variables: { id: task_id })
    end
  end
end
