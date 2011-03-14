module ApplicationHelper


  def link_to_remove_fields(name, f)

    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")

  end

  def link_to_add_fields(name, f, association)

    new_object = f.object.class.reflect_on_association(association).klass.new

    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end

    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

  def devise_error_messages!
    return "" if current_user.errors.empty?

    messages = current_user.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
      :count => current_user.errors.count,
      :resource => @current_user)

    html = <<-HTML
       <div id="error_explanation">
       <h2>#{sentence}</h2>
       <ul>#{messages}</ul>
       </div>
    HTML
    html.html_safe
  end

  def me (profile=@profile)
    current_user.profile == profile
  end

  def full_name(profile)
    [profile.first_name, profile.middle_name, profile.last_name].join(" ")
  end

  def rounded_corner(options = {}, &block)
    raise ArgumentError, "Missing block" unless block_given?
    options.symbolize_keys!
    size = (options[:size] || :lrg).to_s
    title = options[:title] || ""
    concat(content_tag(:div, :class => "widget_#{size}") do
        content_tag(:span, " ", :class => "widget_#{size}_top") +
          content_tag(:h2,title,:class => "widget_#{size}_title") +
          capture(&block) +
          content_tag(:div, "", :class => "clear_div") +
          content_tag(:span, "", :class => "widget_#{size}_btm")
      end)
    ""
  end

  def rounded_med_corner(options = {}, &block)
    raise ArgumentError, "Missing block" unless block_given?
    options.symbolize_keys!
    title = options[:title] || ""
    id = options[:id] || title
    button = options[:button] || ""
    click = options[:click]
    dis = options[:display]
    concat(content_tag(:div, :class => "edit_profile", :id => id) do
        content_tag(:span, " ", :class => "edit_profile_top") +
          content_tag(:h2,title,:class => "edit_profile_title", :onclick => "content_show_hide(#{id}_body,#{click})") +
          content_tag(:div, :class => "edit_panel_profile", :id =>"#{id}_body", :style => "display: #{dis};") do
          capture(&block)
        end +
          content_tag(:div, "", :class => "clear_div") +
          content_tag(:span, "", :class => "edit_profile_btm")
      end + (button.blank? ? "" : content_tag(:div, :class => "large_btn_container") do
          content_tag(:button, theme_image(button), :class => "buttons", :type => "submit")
        end))
    ""
  end

  def formatted_error_message(*params)
    options = params.extract_options!.symbolize_keys
    if object = options.delete(:object)
      objects = [object].flatten
    else
      objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    end
    count   = objects.inject(0) {|sum, object| sum + object.errors.count }
    unless count.zero?
      html = {}
      [:id, :class].each do |key|
        if options.include?(key)
          value = options[key]
          html[key] = value unless value.blank?
        else
          error_message_class = 'error_msg' + " " + "widget_flash_msg"
          html[key] = error_message_class
        end
      end
      options[:object_name] ||= params.first
      options[:message] ||= 'There were some problems with your submission:' unless options.include?(:message)
      error_messages = objects.map {|object| object.errors.full_messages}
      content_tag(:div,html) do
        content_tag(:ul) do
          error_messages.flatten.map do |msg|
            content_tag(:li,msg)
          end.join(" ").html_safe
        end +
          content_tag(:span,"",:class =>'widget_flash_msg_btm')
      end
    else
      ''
    end
  end

  def set_icon(profile, size)
    if profile.icon_file_name.blank?
      "#{profile.gender}_#{size}.png"
    else
      profile.icon.url(size)
    end
  end

  def theme_image(img, options = {})
    "#{image_tag((THEME_IMG + "/" + img), options)}"
  end

   def slide_up_down_header(inner_panel_style,
      inner_panel_id,
      header_text)
    img_src = inner_panel_style == 'hide' ? 'show.jpg' : 'hide.jpg'
    content_tag:a,
      :class => "widget_lrg_title",
      :id => inner_panel_id+"_header",
      :onclick => "new Effect.SlideUpAndDown('#{inner_panel_id}', '#{inner_panel_id}_header', this);" do
      header_text
    end
  end

 def display_standard_flashes(message = 'There were some problems with your submission:')
    if flash[:notice]
      flash_to_display, level = flash[:notice], 'notice'
      flash_message_class = 'notice_msg'
    elsif flash[:warning]
      flash_to_display, level = flash[:warning], 'warning'
      flash_message_class = 'warning_msg'
    elsif flash[:error]
      flash_message_class = 'error_msg'
      level = 'error'
      if flash[:error].instance_of?( ActiveRecord::Errors) || flash[:error].is_a?( Hash)
        flash_to_display = message
        flash_to_display << activerecord_error_list(flash[:error])
      else
        flash_to_display = flash[:error]
      end
    else
      return
    end
    flash_message_class = flash_message_class.to_s + " " + "widget_flash_msg"
    flash_msg = flash_to_display.to_s + "<span class='widget_flash_msg_btm'></span>"
    content_tag 'div', flash_msg.html_safe, :class => flash_message_class, :id => "flash_message"
  end

  def display_standard_flashes_in_large_size(message = 'There were some problems with your submission:')
    if flash[:notice]
      flash_to_display, level = flash[:notice], 'notice'
      flash_message_class = 'notice_msg'
    elsif flash[:warning]
      flash_to_display, level = flash[:warning], 'warning'
      flash_message_class = 'warning_msg'
    elsif flash[:error]
      flash_message_class = 'error_msg'
      level = 'error'
      if flash[:error].instance_of?( ActiveRecord::Errors) || flash[:error].is_a?( Hash)
        flash_to_display = message
        flash_to_display << activerecord_error_list(flash[:error])
      else
        flash_to_display = flash[:error]
      end
    else
      return
    end
    flash_message_class = flash_message_class.to_s + " " + "widget_large_flash_msg"
    flash_msg = flash_to_display.to_s + "<span class='widget_large_flash_msg_btm'></span>"
    content_tag 'div', flash_msg.html_safe, :class => flash_message_class, :id => "flash_message"
  end
 
  def message_count(profile = @p)
    c = profile.unread_messages.size
    "(#{c})" if c > 0
  end

end