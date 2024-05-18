class CleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    puts "-----------------------------------------------------------"
    puts "Running a background task"
    puts "-----------------------------------------------------------"
  end
end
