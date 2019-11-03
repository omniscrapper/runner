require './lib/api/task_info'
require 'json'

module Domain
  class Task
    attr_reader :id, :crawler, :schema_definition, :site, :scrapper_params,
      :crawler_params, :result

    # TODO: validate response from API
    def initialize(task_id, api_class = Api::TaskInfo)
      @id = task_id
      @result = api_class.new.call(task_id: task_id).to_h
      assign_fields
    end

    private

    def assign_fields
      @crawler = task_params.dig('crawler')
      @site = Site.new(task_params.dig('site'))

      @schema_definition = task_params.dig('schema', 'definition')

      @crawler_params = JSON.parse(task_params.dig('crawlerParams'))
      @scrapper_params = JSON.parse(task_params.dig('scrapperParams'))
    end

    def task_params
      @task_params ||= @result.dig('data', 'task')
    end

    class Site
      attr_reader :id, :name, :url

      def initialize(params)
        @id = params['id']
        @name = params['name']
        @url = params['url']
      end
    end
  end
end
