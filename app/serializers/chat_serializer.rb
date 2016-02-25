class ChatSerializer < ActiveModel::Serializer
  attributes :id, :from_user, :to_user, :message
end
