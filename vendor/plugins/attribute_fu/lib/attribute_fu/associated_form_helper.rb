module AttributeFu
  # Methods for building forms that contain fields for associated models.
  #
  # Refer to the Conventions section in the README for the various expected defaults.
  #
  module AssociatedFormHelper
    # Renders the form of an associated object, wrapping it in a fields_for_associated_object or fields_for_associated_collection call.
    #
    # The +associated+ argument can either be a single model object (in the case of has_one/belongs_to), or a collection of objects to be rendered (in the case of has_many).
    #
    # If it is a single object, it is assumed to be for a *singular* association (has_one/belongs_to) and it will use fields_for_associated_object.
    # If it is an array of objects, it is treated as a has_many association and it will use fields_for_associated_collection.
    #
    # Note that this is different than the previous version of the method, which assumed that it was rendering a form for a has_many association even if you passed in a single object!
    #
    # Also be careful that you don't pass nil for the +associated+ object, since that will raise an error. For singular associations (has_one/belongs_to), the association will return nil if no model has been associated yet, so you need to take care and ensure that the association is built if it does not exist yet. You can, for example, use @user.address || @user.build_address, which will use the user's address if it already has one or build one if it doesn't.
    #
    # This isn't as much of a problem for has_many associations, because they always return an array, even if it is an empty array. So for a has_many association, you don't need to build the association first.
    #
    # An +options+ hash can be specified to override the default behaviors.
    #
    # Options are:
    # * <tt>:new</tt>        - specify a certain number of blank elements to be added to the form (usually at the bottom). Saves the user from having
    #                          to manually click the 'Add new' link that many times.
    # * <tt>:name</tt>       - override the name of the association, both for the field names, and the name of the partial
    # * <tt>:partial</tt>    - specify the name of the partial in which the form is located.
    # * <tt>:fields_for</tt> - specify additional options for the fields_for_associated call
    # * <tt>:locals</tt>     - specify additional variables to be passed along to the partial
    # * <tt>:render</tt>     - specify additional options to be passed along to the render :partial call
    #
    # (The name render_associated_form is bit misleading in that it doesn't actually create a new *form*; what it does create is a form *builder* that will namespace any fields you create with it (within an existing form for a parent model) so that those fields will result in params that are compatible with attribute_fu.)
    #
    def render_associated_form(associated, opts = {})
      if associated.nil?
        raise ArgumentError, 'You must supply an object or a collection of objects.'
      elsif associated.is_a?(Array)
        opts.symbolize_keys!
        (opts[:new] - associated.select(&:new_record?).length).times { associated.build } if opts[:new]

        unless associated.empty?
          name              = extract_option_or_class_name(opts, :name, associated.first)
          partial           = opts[:partial] || name
          local_assign_name = partial.split('/').last.split('.').first

          associated.map do |element|
            fields_for_associated_collection(element, (opts[:fields_for] || {}).merge(:name => name)) do |f|
              @template.render({
                                 :partial => partial,
                                 :locals => {local_assign_name.to_sym => element, :f => f}.merge(opts[:locals] || {})
                               }.merge(opts[:render] || {}))
            end
          end
        end
      else
        name              = extract_option_or_class_name(opts, :name, associated)
        partial           = opts[:partial] || name
        local_assign_name = partial.split('/').last.split('.').first

        fields_for_associated_object(associated, (opts[:fields_for] || {}).merge(:name => name)) do |f|
          @template.render({
                             :partial => partial,
                             :locals => {local_assign_name.to_sym => associated, :f => f}.merge(opts[:locals] || {})
                           }.merge(opts[:render] || {}))
        end
      end
    end
    

    #-----------------------------------------------------------------------------------------------
    # Helpers for singular associations

    # Works similarly to fields_for, but used for building forms for a singular (has_one/belongs_to) associated object.
    #
    # Automatically names fields to be compatible with the association_attributes= created by attribute_fu.
    #
    # For example:
    #   <% f.fields_for_associated_object(@user.address || @user.build_address) do |address_form| %>
    #     <%= address_form.text_field :city %>
    #
    # would produce fields named:
    #   user[address_attributes][city]
    #
    # An options hash can be specified to override the default behaviors.
    #
    # Options are:
    # <tt>:name</tt>        - Specify the singular name of the association (in singular form), if it differs from the class name of the object.
    #
    # Any other supplied parameters are passed along to fields_for.
    #
    # Note: It is preferable to call render_associated_form, which will automatically wrap your form partial in a fields_for_associated_object call.
    #
    def fields_for_associated_object(associated, *args, &block)
      conf            = args.last.is_a?(Hash) ? args.last : {}
      associated_name = extract_option_or_class_name(conf, :name, associated)
      name            = associated_base_name associated_name
      
      @template.fields_for(name, *args.unshift(associated), &block)
    end

    #-----------------------------------------------------------------------------------------------
    # Helpers for has_many associations

    # Works similarly to fields_for, but used for building a form for a collection of associated objects (a has_many association).
    #
    # Automatically names fields to be compatible with the association_attributes= created by attribute_fu.
    #
    # For example:
    #   <% f.fields_for_associated_collection((@photo.comments.build; @photo.comments)) do |comment_form| %>
    #     <%= comment_form.text_field :comment_text %>
    #
    # would produce fields named:
    #   photo[comment_attributes][new][0][comment_text]
    #
    # An options hash can be specified to override the default behaviors.
    #
    # Options are:
    # <tt>:javascript</tt>  - Generate id placeholders for use with Prototype's Template class (this is how attribute_fu's add_associated_link works).
    # <tt>:name</tt>        - Specify the singular name of the association (in singular form), if it differs from the class name of the object.
    #
    # Any other supplied parameters are passed along to fields_for.
    #
    # Note: It is preferable to call render_associated_form, which will automatically wrap your form partial in a fields_for_associated_collection call.
    #
    def fields_for_associated_collection(associated, *args, &block)
      conf            = args.last.is_a?(Hash) ? args.last : {}
      associated_name = extract_option_or_class_name(conf, :name, associated)
      name            = associated_base_name associated_name
      
      unless associated.new_record?
        name << "[#{associated.new_record? ? 'new' : associated.id}]"
      else
        @new_objects ||= {}
        @new_objects[associated_name] ||= -1 # we want naming to start at 0
        identifier = !conf.nil? && conf[:javascript] ? '${number}' : @new_objects[associated_name]+=1
        
        name << "[new][#{identifier}]"
      end
      
      @template.fields_for(name, *args.unshift(associated), &block)
    end
    
    # Creates a link for removing an associated element from the form, by removing its containing element from the DOM.
    #
    # Assuming your app is set up to use attribute_fu, that element will be also removed from the association collection when you submit the form.
    #
    # Must be called from within the associated form builder.
    #
    # app/views/projects/_task.html.erb:
    #   <%= f.remove_link "remove" %>
    #
    # An options hash can be specified to override the default behaviors.
    #
    # Options are:
    # * <tt>:selector</tt>  - The CSS selector with which to find the element to remove.
    # * <tt>:function</tt>  - Additional javascript to be executed before the element is removed.
    #
    # Any remaining options are passed along to link_to_function
    #
    def remove_link(name, *args)
      options = args.extract_options!

      css_selector = options.delete(:selector) || ".#{@object.class.name.split("::").last.underscore}"
      function     = options.delete(:function) || ""
      
      function << "$(this).parents('#{css_selector}').remove()"
      
      @template.link_to_function(name, function, *args.push(options))
    end
    
    # Creates a link that adds a new associated field set to the page using Javascript.
    #
    # Must be called from within the parent form builder and refer to an associated has_many field set.
    #
    # app/views/projects/_form.html.erb:
    #   <div id="tasks">
    #     <%= f.render_associated_form(@project.tasks, :new => 3) %>
    #   </div>
    #   <%= f.add_associated_link "Add New Task", @project.tasks.build %>
    #
    # Must be provided with a new instance of the associated object (usually built using something like @project.tasks.build).
    #
    # An options hash can be specified to override the default behaviors.
    #
    # Options are:
    # * <tt>:partial</tt>    - specify the name of the partial in which the form is located.
    # * <tt>:container</tt>  - specify the DOM id of the container in which to insert the new element.
    # * <tt>:expression</tt> - specify a javascript expression with which to select the container to insert the new form in to (i.e. $(this).up('.tasks'))
    # * <tt>:name</tt>       - specify an alternate class name for the associated model (underscored)
    # * <tt>:javascript</tt> - specify additional JavaScript to invoke when the user clicks the link (defaults to <tt>jQuery(#{container}).find('input:last').focus()</tt>.)
    #
    # Any additional options are forwarded to link_to_function. See its documentation for available options.
    #
    def add_associated_link(name, associated, opts = {})
      associated_name  = extract_option_or_class_name(opts, :name, associated)
      variable         = "attribute_fu_#{associated_name}_count"
      
      opts.symbolize_keys!
      partial          = opts.delete(:partial)    || associated_name
      container        = opts.delete(:expression) || "'#{opts.delete(:container) || '#'+associated_name.pluralize}'"
      javascript       = opts.delete(:javascript) || "jQuery(#{container}).find('input:last').focus()"

      rendered_forms = self.render_associated_form([associated], :fields_for => { :javascript => true }, :partial => partial)

      function = "if (typeof #{variable} == 'undefined') { #{variable} = 0; }
                  $(#{container}).append($.template("+rendered_forms.first.to_json+"), { number: --#{variable}});
                  #{javascript}"
                    
      @template.link_to_function(name, function, opts)
    end
    
  private
    def associated_base_name(associated_name)
      "#{@object_name}[#{associated_name}_attributes]"
    end
    
    def extract_option_or_class_name(hash, option, object)
      (hash.delete(option) || object.class.name.split('::').last.underscore).to_s
    end
  end
end
