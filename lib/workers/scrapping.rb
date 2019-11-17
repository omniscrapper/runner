require './lib/domain/task'
require './lib/operations/scrappers/build'
require './lib/operations/scrappers/perform'
require './lib/api/job_event'

module Workers
  # Executed when new task comes into sidekiq queue
  # Fetches missing task data from GQL api
  # and starts scrapper
  class Scrapping < Base
    sidekiq_options queue: :scrapping, retry: false

    def perform(task_id)
      Api::JobEvent.new.call(task_id: task_id, job_id: jid, event: 'started')
      task = Domain::Task.new(task_id)
      scrapper_class = Operations::Scrappers::Build.new.call(task, jid)
      Operations::Scrappers::Perform.new.call(scrapper_class, task)
      Api::JobEvent.new.call(task_id: task_id, job_id: jid, event: 'finished')
    rescue => e
      Api::JobEvent.new.call(task_id: task_id, job_id: jid, event: 'failed')
    end
  end
end
