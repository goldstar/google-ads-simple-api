module GoogleAdsSimpleApi
  module HasMutators

    module ClassMethods

      def create!(*hashes)
        new_values = add(hashes.flatten)
        new_objects = new_values.map{|h| self.new(h) }
        return new_objects.first if (hashes.count == 1 && hashes.first.kind_of?(Hash))
        new_objects
      end

      def add(*hashes)
        operations = hashes.flatten.map{ |hash|
          {:operator => 'ADD', :operand => hash}
        }
        response = service.mutate(operations)
        if response && response[:value]
          response[:value]
        else
          []
        end
      end

      def set(id, hash)
        operation = set_operation(id, hash)
        response = service.mutate([operation])
        if response && response[:value]
          response[:value]
        else
          []
        end
      end

      def set_operation(id, hash)
        id_key = field_key(:id)
        { :operator => 'SET', :operand => hash.merge(id_key => id) }
      end

      def add_operation(hash)
        { :operator => 'ADD', :operand => hash }
      end

      def remove_operation(id, hash = {})
        id_key = field_key(:id)
        { :operator => 'REMOVE', :operand => hash.merge(id_key => id) }
      end

    end

    # def save
    #   id.present? ? update : create
    # end

    # def update
    #   set(changed_attributes)
    # end

    # def create
    #   new_values = self.class.add(attributes)
    #   if new_value.first
    #     @attributes = new_values.first
    #   else
    #     raise "No objects were created"
    #   end
    # end

    def set(hash)
      new_values = self.class.set(id, hash)
      if new_values.first
        @attributes = new_values.first
      else
        raise 'No objects were updated.'
      end
    end

    def set_operation(hash)
      self.class.set_operation(self.id, hash)
    end

    def remove_operation
      self.class.remove_operation(self.id)
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
