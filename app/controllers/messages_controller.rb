class MessagesController < ApplicationController
    def create
        conversation = Conversation.find(message_params[:conversation_id])
        message = Message.create!(message_params)

        # DeliverMessageToConversationJob.perform_later(conversation, message)
        
        serialized_data = ActiveModelSerializers::Adapter::Json.new(
                MessageSerializer.new(message)
            ).serializable_hash
        MessagesChannel.broadcast_to conversation, serialized_data
        head :ok
    end

    private

    def message_params
        params.require(:message).permit(:text, :conversation_id, :user_id)
    end
end
