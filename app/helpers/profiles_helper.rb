module ProfilesHelper

def new_map
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([26.6670958011,75.849609375],4)
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
    @profiles = @profile.marker.nil? ? @friends : @friends + [@profile]
    unless @profiles.blank?
      @map.control_init(:large_map => true,:map_type => true)
      @map.set_map_type_init(GMapType::G_HYBRID_MAP)
      markers = @profiles.collect do |f|
        GMarker.new([f.marker.lat,f.marker.lng],
          :title => "#{f.full_name({:is_short => 1})}")
      end
      centre = @profile.marker.nil? ? @friends.first.marker : @profile.marker
      @map.center_zoom_init([centre.lat,centre.lng],centre.zoom)
      @map.overlay_global_init(GMarkerGroup.new(true,markers),"my_friends")
    end
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

  def link_to_friends(type)
    if type == "Group Member"
      link_to("See All", batch_mates_profile_path(@profile))
    else
      link_to("See All", user_friends_profile_path(@profile, :friend_type => type))
    end
  end

  def link_to_event_friends(type,event)
    link_to("See All", event_members_admin_event_path(event, :member_type => type ))
  end
  
end