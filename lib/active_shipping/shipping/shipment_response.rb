module ActiveMerchant #:nodoc:
  module Shipping
    
    class ShipmentResponse < Response
      
      attr_reader :label_data
      attr_reader :receipt_data
      attr_reader :recipient
      attr_reader :tracking_number
      
      alias_method :label, :label_data
      alias_method :receipt, :receipt_data
      alias_method :to, :recipient
      
      def initialize(success, message, params = {}, options = {})
        super
        @label_data = options[:label_data]
        @receipt_data = options[:receipt_data]
        @recipient = options[:recipient]
        @tracking_number = options[:tracking_number]
      end
      
      def save_label(path)
        File.open(path, 'wb') { |f| f.write(label_data) }
      end
      def save_receipt(path)
        File.open(path, 'wb') { |f| f.write(receipt_data) }
      end
      
      def trimmed_label
        img = Magick::Image.from_blob(label).first
        img.rotate! 270
        img.trim! true
        img.to_blob { self.format = 'PDF' }
      end
      def save_trimmed_label(path)
        File.open(path, 'wb') { |f| f.write(trimmed_label) }
      end
      
      def inspect
        ivar_summary = []
        hidden_ivars = [:@label_data, :@receipt_data, :@xml, :@request, :@params]
        (instance_variables - hidden_ivars).each do |ivar|
          ivar_summary << '%s=%s' % [ivar, instance_variable_get(ivar).inspect]
        end
        hidden_ivars.each do |ivar|
          val = instance_variable_get(ivar)
          ivar_summary << '%s=%s' % [ivar, (val.nil? ? val : "...#{ivar} present...").inspect]
        end

        '#<%s:%d %s>' % [self.class.name, self.__id__, ivar_summary.join(' ')]
      end
    end
    
  end
end
