module Operations
  module Scrappers
    class Perform
      def call(scrapper_class, task)
        scrapper_class.run do |result|
          puts result.inspect
        end
      end
    end
  end
end
