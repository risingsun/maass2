module AttributeFu
  module Associations #:nodoc:
    module Singular #:nodoc:
      
      def self.included(base) #:nodoc:
        base.class_eval do
          extend ClassMethods
          class << self; alias_method_chain :has_one,    :attributes_option; end
          class << self; alias_method_chain :belongs_to, :attributes_option; end
          
          class_inheritable_accessor  :attribute_fu_has_one_options
          write_inheritable_attribute :attribute_fu_has_one_options, {}

          class_inheritable_accessor  :attribute_fu_belongs_to_options
          write_inheritable_attribute :attribute_fu_belongs_to_options, {}
        end
      end
    
    private
      def update_has_one_from_attributes(association_name, attributes) #:nodoc:
        object = send(association_name)

        if attributes.nil?
          if dependent = self.class.reflect_on_association(association_name).options[:dependent]
            send "has_one_dependent_#{dependent}_for_#{association_name}"
          end
          send "#{association_name}=", nil
        elsif object
          object.attributes = attributes
        else
          send "build_#{association_name}", attributes
        end
      end

      def update_belongs_to_from_attributes(association_name, attributes) #:nodoc:
        object = send(association_name)

        if attributes.nil?
          if dependent = self.class.reflect_on_association(association_name).options[:dependent]
            send "belongs_to_dependent_#{dependent}_for_#{association_name}"
          end
          send "#{association_name}=", nil
        elsif object
          object.attributes = attributes
        else
          send "build_#{association_name}", attributes
        end
      end
      
      def save_attribute_fu_singular_associations #:nodoc:
        if attribute_fu_has_one_options != nil
          attribute_fu_has_one_options.keys.each do |association_name|
            association = send(association_name)
            if association
              association.save if association.changed?
            end
          end
        end

        if attribute_fu_belongs_to_options != nil
          attribute_fu_belongs_to_options.keys.each do |association_name|
            association = send(association_name)
            if association
              association.save if association.changed?
            end
          end
        end
      end
    
      module ClassMethods
        
        # Behaves identically to the regular has_one, except adds the option <tt>:attributes</tt>, which, if true, creates
        # a method called <association_name>_attributes (i.e. address_attributes, or beneficiary_attributes) for setting the attributes
        # of an associated model.
        #
        # So instead of calling build_<model> or (if it already exists) calling attributes=/update_attributes on the existing associated model,
        # you can simply call <model>_attributes= on the parent model:
        #
        #     @user.address_attributes = {
        #       :line1 => 'A street address',
        #       :city  => 'City'
        #     }
        #
        # If there is already an associated model, it will be updated. If not, one will be built and associated.
        # In either case, it will not actually be saved to the database until you call save on either the parent
        # model or the changed model itself.
        #
        # There is a good chance you will want to add a validates_associated to the parent model so that errors
        # in the child models will show up in the parent and prevent it from being saved after using the
        # <model>_attributes= setter.
        #
        def has_one_with_attributes_option(association_name, options = {}, &extension)
          if !(config = options.delete(:attributes)).nil?
            attribute_fu_has_one_options[association_name] = {}
            define_method("#{association_name}_attributes=") do |attributes|
              update_has_one_from_attributes association_name, attributes
            end
            after_update :save_attribute_fu_singular_associations
          end
          
          has_one_without_attributes_option(association_name, options, &extension)

          if !(config = options.delete(:auto_build)).nil?
            class_eval <<-EOS, __FILE__, __LINE__
              def #{association_name}_with_auto_build(*args)
                ret = #{association_name}_without_auto_build(*args)
                puts "#{association_name}_without_auto_build returned \#{ret}"
                ret or build_#{association_name}
              end
            EOS
            alias_method_chain "#{association_name}", :auto_build
          end
        end

        def belongs_to_with_attributes_option(association_name, options = {}, &extension)
          if !(config = options.delete(:attributes)).nil?
            attribute_fu_belongs_to_options[association_name] = {}
            define_method("#{association_name}_attributes=") do |attributes|
              update_belongs_to_from_attributes association_name, attributes
            end
            after_update :save_attribute_fu_singular_associations
          end
          
          belongs_to_without_attributes_option(association_name, options, &extension)
        end
        
      end # ClassMethods
    
    end # Singular
  end # Associations
end # AttributeFu

