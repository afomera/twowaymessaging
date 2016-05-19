class Conversation < ActiveRecord::Base
  belongs_to :person
  belongs_to :user

  has_many :messages
end
