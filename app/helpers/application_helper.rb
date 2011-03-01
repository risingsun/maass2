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

  def icon(profile, size = :small, img_opts = {}, link_opts = {})
    return "" if profile.nil?
    img_opts = {:title => full_name(profile), :alt => full_name(profile), :class => size}.merge(img_opts)
    link_to(avatar_tag(profile, {:gender => profile.gender_str, :size => size, :paperclip_style => size }, img_opts), profile_url(profile), link_opts)
  end

  def rounded_corner(options = {}, &block)

    raise ArgumentError, "Missing block" unless block_given?
    options.symbolize_keys!
    size = (options[:size] || :lrg).to_s
    title = options[:title] || ""

    concat(content_tag(:div, :class => "widget_#{size}"){
        content_tag(:span, " ", :class => "widget_#{size}_top") +
          content_tag(:h2,title,:class => "widget_#{size}_title") +
          capture(&block) +
          content_tag(:div, "", :class => "clear_div") +
          content_tag(:span, "", :class => "widget_#{size}_btm")}) 
    ''
  end
  def theme_image(img, options = {})
    "#{image_tag((img), options)}"
  end

end