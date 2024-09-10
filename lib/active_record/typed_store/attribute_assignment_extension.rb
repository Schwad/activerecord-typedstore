# frozen_string_literal: true

module ActiveRecord
  module TypedStore
    module AttributeAssignmentExtension
      def _assign_attributes(attributes)
        # In the event that the attributes hash contains keys that are also keys in the typed_stores hash,
        # we should prioritize the attributes hash.
        attributes.each do |k, v|
          key = k.to_s
          if v.is_a?(Hash) && typed_store?(key)
            v_keys_symbols = v.keys.map(&:to_sym)
            matching_keys = attributes.keys.select { |attr_key| v_keys_symbols.include?(attr_key.to_sym) }

            matching_keys.each do |matching_key|
              v[matching_key.to_s] = attributes[matching_key]
            end
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
