module Sync
  module Clients
    class Faye
      class Message
        def self.batch_publish(messages)
          messages.each do |message|
            message.publish
          end
        end
      end
    end
  end
end