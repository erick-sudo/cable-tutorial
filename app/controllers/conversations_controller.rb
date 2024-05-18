class ConversationsController < ApplicationController
    def index
        render json: Conversation.order(updated_at: :desc)
    end

    def create
        # Create a conversation
        conversation = Conversation.create!(conversation_params)

        # # Delegate deliver to a background job
        # DeliverConversationJob.perform_later(conversation)

        serialized_data = ActiveModelSerializers::Adapter::Json.new(
                ConversationSerializer.new(conversation)
            ).serializable_hash
        ActionCable.server.broadcast 'conversations_channel', serialized_data

        head :ok
    end

    private

    def conversation_params
        params.require(:conversation).permit(:title)
    end
end
