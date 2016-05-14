Rails.application.configure do
  config.active_job.queue_adapter = :sucker_punch
end

require 'sucker_punch/async_syntax'
