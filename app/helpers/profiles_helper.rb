module ProfilesHelper

   def new_map
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([75.5,-42.56],4)
    @map.overlay_init(GMarker.new([75.6,-42.467],:title => "Hello", :info_window => "Info! Info!"))
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
    unless @profiles.blank?
      @map.control_init(:large_map => true,:map_type => true)
      @map.set_map_type_init(GMapType::G_HYBRID_MAP)
      markers = @profiles.collect do |f|
        GMarker.new([f.marker.lat,f.marker.lng],
          :title => "#{f.full_name({:is_short => 1})}",
          :info_window => "#{icon(f)} #{f.full_name({:is_short=>1})}'s Location.")
      end
      p = @profile ? @profile : @p
      centre = p.marker.nil? ? @profiles.first.marker : p.marker
      @map.center_zoom_init([centre.lat,centre.lng],centre.zoom)
      @map.overlay_global_init(GMarkerGroup.new(true,markers),"my_friends")
    end
  end
end

