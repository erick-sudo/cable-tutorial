class MessageSerializer < ActiveModel::Serializer
  attributes :id, :text, :viewed, :created_at, :conversation_id, :user_id
end
