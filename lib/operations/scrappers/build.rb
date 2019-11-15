require 'omni_scrapper'
require './lib/api/scrapping/success'
require './lib/api/scrapping/failure'

module Operations
  module Scrappers
    # Creates scrapper class based on provided task configuration
    class Build
      def call(task, job_id)
        OmniScrapper.setup(scrapper_name(task)) do |config|
          config.scrapping_error_handler = scrapping_error_handler(task, job_id)
          config.scrapping_success_handler = scrapping_success_handler(task, job_id)

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

      # TODO: probably all those event's will generate too many synchronous calls
      # which may slow down scrapping process.
      # Consider switching to kafka for event notifications.
      def scrapping_error_handler(task, job_id)
        -> (uri, ex) do
          Api::Scrapping::Failure.new.call(
            exception: ex, 
            url: uri,
            task_id: task.id,
            job_id: job_id
          )
        end
      end

      def scrapping_success_handler(task, job_id)
        -> (uri, result) do
          Api::Scrapping::Success.new.call(
            url: uri,
            task_id: task.id,
            job_id: job_id,
            checksum: result.checksum
          )
        end
      end
    end
  end
end
