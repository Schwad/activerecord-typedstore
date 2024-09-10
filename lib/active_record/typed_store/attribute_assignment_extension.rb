# frozen_string_literal: true

module ActiveRecord
  module TypedStore
    module AttributeAssignmentExtension
      def _assign_attributes(attributes)
        attributes.each do |k, v|
          key = k.to_s

          if v.is_a?(Hash) && typed_store?(key)
            _assign_attribute(key, v)
            attributes.delete(k)
          end
        end

        super(attributes)
      end

      private

      def typed_store?(key)
        self.class.respond_to?(:typed_stores) && self.class.typed_stores&.key?(key.to_sym)
      end
    end
  end
end

ActiveRecord::AttributeAssignment.prepend ActiveRecord::TypedStore::AttributeAssignmentExtension
