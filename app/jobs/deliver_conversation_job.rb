class DeliverConversationJob < ApplicationJob
  queue_as :default

  def perform(conversation)
    # Deliver conversation to the conversations channel
    serialized_data = ActiveModelSerializers::Adapter::Json.new(
      ConversationSerializer.new(conversation)
    ).serializable_hash
    ActionCable.server.broadcast 'conversations_channel', serialized_data
  end
end
