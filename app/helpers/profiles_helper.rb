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

  def year_link profile = @p
    link_to profile.group, "#"
  end

  def before_after(field_index)
    if field_index < 0
      return "recent"
    elsif field_index == 0
      return "today"
    end
    return "upcoming"
  end
  
end