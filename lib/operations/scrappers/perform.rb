require 'omniscrapper_output'

module Operations
  module Scrappers
    class Perform
      def call(scrapper_class, task)
        scrapper_class.run do |result|
          # TODO: invoke hook before
          ::OmniScrapperOutput::Target
            .new(task.output_params)
            .call(result.to_h)
        end
      end
    end
  end
end
