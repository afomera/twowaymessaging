class SendSmsJob < ActiveJob::Base
  queue_as :default

  def perform(message)
    SMS.new(message.to).send(message.body)
    message.update_columns(status: 'sent')
  end
end
