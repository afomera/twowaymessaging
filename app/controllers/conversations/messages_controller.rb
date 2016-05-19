class Conversations::MessagesController < ApplicationController
  before_action :authenticate_user!, except: [:reply]
  before_action :set_conversation, except: [:reply]
  skip_before_action :verify_authenticity_token, only: [:reply]

  def index
    @messages = @conversation.messages.order("created_at ASC")
    @message = @conversation.messages.build
  end

  def create
    @message = @conversation.messages.build(message_params)

    @message.update(to: @conversation.person.phone, status: 'pending', direction: 'outbound-api')

    if @message.save
      SendSmsJob.perform_later(@message)
      redirect_to conversation_messages_path(@conversation), notice: 'Message sent'
    else
      redirect_to conversation_messages_path(@conversations), alert: 'Something went wrong'
    end
  end

  def reply
    # handle Twilio POST here
    from = params[:From].gsub(/^\+\d/, '')
    body = params[:Body]
    status = params[:SmsStatus]
    direction = 'inbound'
    message_sid = params[:MessageSid]

    # Find the conversation it should belong to.
    person = Person.where("phone like ?", "%#{from}%").first
    @conversation = Conversation.where(person: person).first
    @conversation.messages.build(body: body, direction: direction, status: status, from: from, message_sid: message_sid).save
    # the head :ok tells everything is ok
    # This stops the nasty template errors in the console
    head :ok, content_type: "text/html"
  end

  private
    def set_conversation
      @conversation = current_user.conversations.find(params[:conversation_id])
    end

    def message_params
      params.require(:message).permit(:body)
    end
end
