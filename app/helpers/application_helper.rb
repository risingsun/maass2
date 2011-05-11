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

  def me(profile=@profile)
    current_user.profile == profile
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
    concat(content_tag(:div, :class => "edit_profile", :id => id) do
        content_tag(:span, " ", :class => "edit_profile_top") +
          content_tag(:h2,title,:class => "edit_profile_title") +
          content_tag(:div, :class => "edit_panel_profile") do
          capture(&block)
        end +
          content_tag(:div, "", :class => "clear_div") +
          content_tag(:span, "", :class => "edit_profile_btm")
      end + (button.blank? ? "" : content_tag(:div, :class => "large_btn_container") do
          content_tag(:button, theme_image(button), :class => "buttons", :type => "submit")
        end))
    ""
  end

  def slide_up_down_header(inner_panel_id, header_text, sliding="")
    content_tag :h2, :class => "widget_lrg_title #{sliding}", :id => inner_panel_id + "_header" do
      header_text
    end
  end

  def set_icon(profile, size)
    if profile.icon_file_name.blank?
      "#{profile.gender}_#{size}.png"
    else
      profile.icon.url(size)
    end
  end

  def activerecord_error_list(errors)
    error_list = '<ul class="error_list">'
    error_list << errors.collect do |e, m|
      "<li>#{e.humanize unless e == "base"} #{m}</li>"
    end.to_s << '</ul>'
    error_list
  end
 
  def profile_message_count(profile)
    c = profile.unread_messages.size
    "(#{c})" if c > 0
  end

  def formtastic_zebra(options = {})
    options.reverse_merge!(:wrapper_html => {:class => zebra})
  end

  def zebra(odd = :row_light, even = :row_dark)
    cycle(odd,even)
  end

  def formtastic_zebra2(options = {})
    options.reverse_merge!(:wrapper_html => {:class => zebra2})
  end

  def zebra2(odd = :row_light2, even = :row_dark2)
    cycle(odd,even)
  end

end