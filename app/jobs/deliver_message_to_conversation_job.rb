class DeliverMessageToConversationJob < ApplicationJob
  queue_as :default

  def perform(conversation, message)
    # Delivering message to its appropriate conversation's messages channel
    serialized_data = ActiveModelSerializers::Adapter::Json.new(
      MessageSerializer.new(message)
    ).serializable_hash
    MessagesChannel.broadcast_to conversation, serialized_data
  end
end
