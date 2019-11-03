require './lib/domain/task'
require './lib/operations/scrappers/build'
require './lib/operations/scrappers/perform'

require 'pry'
module Workers
  # Executed when new task comes into sidekiq queue
  # Fetches missing task data from GQL api
  # and starts scrapper
  class Scrapping < Base
    sidekiq_options queue: :scrapping, retry: false

    def perform(task_id)
      task = Domain::Task.new(task_id)
      scrapper_class = Operations::Scrappers::Build.new.call(task)
      Operations::Scrappers::Perform.new.call(scrapper_class, task)
    end
  end
end
