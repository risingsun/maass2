module AttributeFu
  module Associations #:nodoc:
    module HasMany #:nodoc:
      
      def self.included(base) #:nodoc:
        base.class_eval do
          extend ClassMethods
          class << self; alias_method_chain :has_many, :attributes_option; end
          
          class_inheritable_accessor  :attribute_fu_has_many_options
          write_inheritable_attribute :attribute_fu_has_many_options, {}
        end
      end
      
    private
      def update_has_many_from_attributes(association_name, attributes) #:nodoc:
        association = send(association_name)
        attributes = {} unless attributes.is_a? Hash

#        attributes.symbolize_keys!
        
        if attributes.has_key?(:new)
          new_attrs = attributes.delete(:new)
          new_attrs = new_attrs.sort do |a,b|
            value = lambda { |i| i < 0 ? i.abs + new_attrs.length : i }
            
            value.call(a.first.to_i) <=> value.call(b.first.to_i)
          end
          new_attrs.each { |i, new_attrs| association.build new_attrs } 
        end
        
        attributes.stringify_keys!        
        instance_variable_set removal_variable_name(association_name), association.reject { |object| object.new_record? || attributes.has_key?(object.id.to_s) }.map(&:id)
        attributes.each do |id, object_attrs|
          object = association.detect { |associated| associated.id.to_s == id }
          object.attributes = object_attrs unless object.nil?
        end
        
        # discard blank attributes if discard_if proc exists
        unless (discard = attribute_fu_has_many_options[association_name][:discard_if]).nil?
          association.reject! { |object| object.new_record? && discard.call(object) }
          association.delete(*association.select { |object| discard.call(object) })
        end
      end
      
      def save_attribute_fu_has_many_associations #:nodoc:
        if attribute_fu_has_many_options != nil
          attribute_fu_has_many_options.keys.each do |association_name|
            if send(association_name).loaded? # don't save what we haven't even loaded
              association = send(association_name)
              association.each(&:save)

              unless (objects_to_remove = instance_variable_get removal_variable_name(association_name)).nil?
                objects_to_remove.each { |remove_id| association.delete association.detect { |obj| obj.id.to_s == remove_id.to_s } }
                instance_variable_set removal_variable_name(association_name), nil
              end
            end
          end
        end
      end
      
      def removal_variable_name(association_name) #:nodoc:
        "@#{association_name.to_s.pluralize}_to_remove"
      end
    
      module ClassMethods
        
        # Behaves identically to the regular has_many, except adds the option <tt>:attributes</tt>, which, if true, creates
        # a method called association_name_attributes (i.e. task_attributes, or comment_attributes) for setting the attributes
        # of a collection of associated models. 
        #
        # It also adds the option <tt>:discard_if</tt>, which accepts a proc or a symbol. If the proc evaluates to true, the 
        # child model will be discarded. The symbol is sent as a message to the child model instance; if it returns true,
        # the child model will be discarded.
        # 
        # e.g.
        #
        #   :discard_if => proc { |comment| comment.title.blank? }
        #     or
        #   :discard_if => :blank? # where blank is defined in Comment
        #  
        #
        # The format is as follows:
        #
        #     @project.task_attributes = {
        #       @project.tasks.first.id => {:title => "A new title for an existing task"},
        #       :new => {
        #         "0" => {:title => "A new task"}
        #       }
        #     }
        #
        # Any existing tasks that are not present in the attributes hash will be removed from the association when the (parent) model
        # is saved.
        #
        def has_many_with_attributes_option(association_name, options = {}, &extension)
          unless (config = options.delete(:attributes)).nil?
            attribute_fu_has_many_options[association_name] = {}
            if options.has_key?(:discard_if)
              discard_if = options.delete(:discard_if)
              discard_if = discard_if.to_proc if discard_if.is_a?(Symbol)
              attribute_fu_has_many_options[association_name][:discard_if] = discard_if
            end
            define_method("#{association_name.to_s.singularize}_attributes=") do |attributes|
              update_has_many_from_attributes association_name, attributes
            end
            after_update :save_attribute_fu_has_many_associations
          end
          
          has_many_without_attributes_option(association_name, options, &extension)
        end
        
      end # ClassMethods
    
    end # HasMany
  end # Associations
end # AttributeFu

