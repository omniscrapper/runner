require './lib/api/task_info'
require 'json'

module Domain
  # Simple data transfer object that takes API response and provides
  # unified interface to it.
  class Task
    attr_reader :id, :crawler, :schema_definition, :site, :scrapper_params,
      :crawler_params, :result

    # TODO: validate response from API
    def initialize(task_id, api_class = Api::TaskInfo)
      @id = task_id
      @result = api_class.new.call(task_id: task_id).to_h
      assign_fields
    end

    def output_params
      adapter = task_params.dig('output', 'adapter')
      params = JSON.parse(task_params.dig('output', 'adapterParams')).reduce({}) do |result, (key, value)|
        result.merge(key.to_sym => value)
      end
      params.merge(target_type: adapter)
    end

    private

    def assign_fields
      @crawler = task_params.dig('crawler')
      @site = Site.new(task_params.dig('site'))

      @schema_definition = JSON.parse(task_params.dig('schema', 'definition'))

      @crawler_params = JSON.parse(task_params.dig('crawlerParams'), symbolize_names: true)
      @scrapper_params = JSON.parse(task_params.dig('scrapperParams'), symbolize_names: true)
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
