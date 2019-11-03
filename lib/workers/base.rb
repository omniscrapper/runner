module Workers
  class Base
    include Sidekiq::Worker

    def perform
      raise NotImplementedError, 'implement perform in child class'
    end
  end
end
