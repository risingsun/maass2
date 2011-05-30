module ProfilesHelper

  def new_map
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([GOOGLE_MAP_DEFAULT_LAT,GOOGLE_MAP_DEFAULT_LON],GOOGLE_MAP_DEFAULT_ZOOM)
    @map.record_init('create_draggable_editable_marker();')
  end

  def edit_map(marker)
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([marker.lat,marker.lng],marker.zoom)
    @map.record_init("create_draggable_marker_for_edit(#{marker.lat},#{marker.lng},#{marker.zoom});")
  end

  def show_map
    @map = GMap.new("map_div")
    if @event
      marker = create_marker(@event.marker, @event.title, 'event', '/images/yellow_star.png')
    elsif(@profile.marker)
      marker = create_marker(@profile.marker, @profile.full_name({:is_short => 1}), 'user', '/images/yellow-dot.png')
      @friends.delete(@profile)
    end
    unless @friends.blank? && marker.blank?
      @map.control_init(:large_map => true,:map_type => true)
      @map.set_map_type_init(GMapType::G_HYBRID_MAP)
      markers = @friends.collect do |f|
        create_marker(f.marker, f.full_name({:is_short => 1}))
      end
      markers = markers.insert(0,marker);
      centre = @event ? @event.marker : (@profile.marker.blank? ? @friends.first.marker : @profile.marker)
      @map.center_zoom_init([centre.lat,centre.lng],centre.zoom)
      @map.overlay_global_init(GMarkerGroup.new(true,markers),"my_friends")
    end
  end

  def create_marker(marker, title, image = 'marker', image_url = '/images/marker.png')
    info = marker.profile ? set_icon(marker.profile, 'small_60') : '/images/event_star.jpeg'
    GMarker.new([marker.lat,marker.lng],
          :title => "#{title}", 
          :icon => icon_for_google_map("#{image}","#{image_url}"),
          :info_window => "#{image_tag(info)} #{title}'s Location.")
  end

  def icon_for_google_map(icon_name, icon_url)
    @map.icon_global_init(
    GIcon.new(:image => "#{icon_url}",
              :icon_anchor => GPoint.new(16, 32),
              :info_window_anchor => GPoint.new(16, 0)), "#{icon_name}")
     return Variable.new("#{icon_name}")
  end

  def location_link profile = @p
    return profile.location if profile.location == Profile::NOWHERE
    link_to(profile.location, search_location_profiles_path('search[location]' => profile.location))
  end

  def year_link profile
    link_to(profile.group, search_group_profiles_path('search[group]' => profile.group))
  end

  def before_after(field_index)
    if field_index < 0
      return "recent"
    elsif field_index == 0
      return "today"
    end
    return "upcoming"
  end

  def linkedin_badge(linkedin_name)
    str = ""
    unless linkedin_name.blank?
      str = "<a href='#{linkedin_name}' class = 'linkedin-profileinsider-popup'>"
      str += "<img src='http://www.linkedin.com/img/webpromo/btn_myprofile_160x33.gif' width='160' height='33' border='0' alt='View #{@profile.full_name}'s profile on LinkedIn' style='background:none;' class = 'linkedin-profileinsider-popup'></a>"
    end
    str.html_safe
  end

  def skype_status(skype_account)
    str = ""
    unless skype_account.blank?
      str = "<br /><b>Skype:</b> #{skype_account}"
      str += '<script type="text/javascript" src="http://download.skype.com/share/skypebuttons/js/skypeCheck.js"></script>'
      str += "<img src='http://mystatus.skype.com/bigclassic/#{skype_account}' style='border: none;' width='182' height='44' alt='My status' />"
    end
    str.html_safe
  end

  def msn_status(msn_account)
    str = ""
    unless msn_account.blank?
      str = "<b>MSN:</b> #{msn_account}<br/>"
    end
    str.html_safe
  end

  def yahoo_status(yahoo_username)
    str = ""
    unless yahoo_username.blank?
      str = "<b>Yahoo:</b> #{yahoo_username}<br/>"
    end
    str.html_safe
  end

  def show_field(field_value,field_name,field)
    if !field_value.blank? && @profile.can_see_field(field, @p)
      "<tr><th align='right'>#{field_name} </th><td>#{field_value}</td></tr>".html_safe
    else
      ""
    end
  end

  def see_all_user(profiles, type)
    size = profiles.length
    if size > 6
      if @event
        link_to("(#{size}) See All", event_members_admin_event_path(@event, :member_type => type))
      else
        link_to("(#{size}) See All", user_friends_profile_path(@profile, :friend_type => type))
      end
    end
  end
end