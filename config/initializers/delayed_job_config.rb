Delayed::Worker.destroy_failed_jobs = true
Delayed::Worker.max_attempts = 2
Delayed::Worker.max_run_time = 1.hours # 72.hours
Delayed::Worker.read_ahead = 5
Delayed::Worker.logger = Logger.new(Rails.root.join('log', 'delayed.log'))