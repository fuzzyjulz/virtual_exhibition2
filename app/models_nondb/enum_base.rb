#Enum base provdes a few handy helper methods for dealing with enums. This concern expects
# a constant ENUM that is an array of hashes of the options available for the item. 
# The hash must contain an :id and a :label. Any additional options are available for access.
# 
# It also adds in the following constants to whichever class it is applied to:
#  LABELS - the list of all labels for dropdown lists
#  OPTIONS - options to be provided to the enum on the model. eg:
#             enum privacy: Privacy::OPTIONS
#
# Additionally it provides a method for all of the enum ids, so that you can do:
#  Privacy.private.label or Privacy[:private].label or Privacy["private"].label
#  or Privacy[1].label 
#
# 
#Expects a set ENUM that contains all keys and labels
module EnumBase
  extend ActiveSupport::Concern
  
  #create methods for each of the statuses to return the labels
  included do
    labelCollection = {}
    optionsList = []
    allItems = []
    
    self::ENUM.each_with_index do |enum_option, index|
      newObject = self.new()
      enum_option.each_pair do |key, value|
        newObject.send(:define_singleton_method, key) { value }
      end
      newObject.send(:define_singleton_method, :idx) { index }
      
      ClassMethods.send(:define_method, enum_option[:id]) { newObject }
      allItems << newObject
      
      label = enum_option[:label].present? ? enum_option[:label] : enum_option[:id]
      labelCollection[label] = enum_option[:id]
      optionsList << enum_option[:id]
    end
    self::LABELS = labelCollection
    self::OPTIONS = optionsList
    self::ALL_ITEMS = allItems
  end
  
  module ClassMethods
    def [](key)
      key = self::OPTIONS[key] if key.class == Fixnum
      return nil unless key.present? and (self::OPTIONS.include? key or self::OPTIONS.include? key.to_sym)
      self.send(key)
    end
    
    def all()
      self::ALL_ITEMS
    end
  end
end