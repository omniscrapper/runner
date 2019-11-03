require './lib/domain/task'
require './lib/operations/scrappers/build'
require './lib/operations/scrappers/run'

module Workers
  class Scrapping < Base
    sidekiq_options queue: :scrapping, retry: false

    def perform(task_id)
      task = Domain::Task.new(task_id)
      puts "Task: #{task.inspect}"
      #scrapper_class = Operations::Scrappers::Build.new.call(scrapper_class)
      #Operations::Scrappers::Run.new.call(scrapper_class, task)
    end
  end
end
