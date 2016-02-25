module DelegateTo
  extend ActiveSupport::Concern

  module ClassMethods
    def delegate_to(options)
      delegate_class_obj = options[:class]
      delegate_method_obj = options[:method]
        
      if delegate_method_obj.present?
        delegate_method(delegate_class_obj, delegate_method_obj)
      elsif delegate_class_obj.present?
        delegate_class(delegate_class_obj)
      end
    end
    
    private
      def delegate_class(delegate_class_obj)
        define_method :method_missing, ->(method, *args) do
          delegate = send(delegate_class_obj)
          #puts "#### delegate #{method} to #{delegate.class.name}"
          if delegate.present? and delegate.respond_to?(method)
            delegate.send(method, *args)
          else
            raise "Cannot find method #{method} on class #{delegate.class.name}"
          end
        end
      end
      
      def delegate_method(delegate_class_obj, delegate_method_obj)
        define_method delegate_method_obj, ->(*args) do
          delegate = send(delegate_class_obj)
          #puts "#### delegate #{delegate_method_obj} to #{delegate.class.name}"
          if delegate.present? and delegate.respond_to?(delegate_method_obj)
            delegate.send(delegate_method_obj, *args)
          else
            raise "Cannot find method #{delegate_method_obj} on class #{delegate.class.name}"
          end
        end
      end
  end
end