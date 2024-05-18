class Message < ApplicationRecord

  validates :text, presence: true

  belongs_to :conversation
  belongs_to :user
end