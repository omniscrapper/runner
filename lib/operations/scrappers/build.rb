require 'omni_scrapper'

module Operations
  module Scrappers
    # Creates scrapper class based on provided task configuration
    class Build
      def call(task)
        OmniScrapper.setup(scrapper_name(task)) do |config|
          config.schema task.schema_definition
          config.crawler task.crawler

          task.crawler_params.each do |name, value|
            config.public_send(name, value)
          end

          task.scrapper_params.each do |name, options|
            config.field name.to_sym, options
          end
        end
      end

      private

      def scrapper_name(task)
        "task_#{task.id}_#{task.site.name}_scrapper".to_sym
      end
    end
  end
end
