# YM4R/GM plugin for Rails 3
Note by guilleiguaran: If you need the version for Rails 2.x check this repo: <a href="http://github.com/ewildgoose/ym4r_gm">http://github.com/ewildgoose/ym4r_gm</a>

This is the latest version of the YM4R/GM plugin for Rails (YM4RGMP4R?). Its aim is to facilitate the use of Google Maps from Rails application. It includes and enhances all the web application-related functionalities found in the YM4R gem as of version 0.4.1.


## Getting Started
I present here the most common operations you would want to do with YM4R/GM. Read the rest of the documents if you want more details.

In your controller, here is a typical initialization sequence in action *index*:


>	def index
>	  @map = GMap.new("map_div")
>	  @map.control_init(:large_map => true,:map_type => true)
>	  @map.center_zoom_init([75.5,-42.56],4)
>	  @map.overlay_init(GMarker.new([75.6,-42.467],:title => "Hello", :info_window => "Info! Info!"))
>	end

Here I create a GMap (which will be placed inside a DIV of id *map_div*), add controls (large zoom slider and pan cross + map type selector), set the center and the zoom and add a marker. Of these 4 steps only the creation of the map and the setting of the center and the zoom are absolutely necessary.

In your view, here is what you would have:

>	<html><head><title>Test</title>
>	<%= raw(GMap.header) %>
>	<%= raw(@map.to_html) %>
>	</head><body>
>	<%= raw(@map.div(:width => 600, :height => 400)) %>
>	</body></html>

First you must output the header, used by all the maps of the page: It includes the Google Maps API JS code and the JS helper functions of YM4R/GM. Then we initialize the map by calling *@map.to_html*. In the body, we need a DIV whose +id+ is the same as the one passed to the GMap constructor in the controller. The call to *@map.div* outputs such a DIV. We pass to it options to set the width and height of the map in the style attribute of the DIV. 

**Note that you need to set a size for the map DIV element at some point or the map will not be displayed.** You have a few ways to do this:

* You define it yourself, wherever you want. Usually as part of the layout definition in an external CSS.
* In the head of the document, through a CSS instruction output by *@map.header_width_height*, to which you pass 2 arguments (width and height).
* When outputting the DIV with *@map.div*, you can also pass an option hash, with keys *:width* and *:height* and a style attribute for the DIV element will be output.

You can update the map trough RJS. Here is an action you can call from a *link_remote_tag* which would do this:

>	def update
>	  @map = Variable.new("map")
>	  @marker = GMarker.new([75.89,-42.767],:title => "Update", :info_window => "I have been placed through RJS")
>	end

Here, I first bind the Ruby *@map* variable to the JS variable *map*, which already exists in the client browser. +map+ is by default the name given to a map created from YM4R/GM (this could be overriden by passing a second argument to the GMap constructor). Then I create a marker.

And you would have inside the RJS template for the action:
>	page << raw(@map.clear_overlays)
>	page << raw(@map.add_overlay(@marker))

Here I first clear the map of all overlays. Then I add the marker. Note that the +overlay_init+ is not used anymore since, as its name indicates, this method is only for the initialization of the map.


## Relation between the YM4R gem and the YM4R/GM plugin
They are completely independent from each other.

With the plugin, you don't need the YM4R gem anymore, unless you want to use the tilers or the Ruby helpers for the Yahoo! Maps Building Block API's and the Google Maps geocoding API. Please refer to the documentation of the YM4R gem to know more about the functionalities in it.

Conversely, the YM4R gem does not need the plugin to work.


## Installation
Install like any other Rails plugin:
	rails plugin install git://github.com/guilleiguaran/ym4r_gm.git

As part of the installation procedure, the JavaScript files found in the *PLUGIN_ROOT/javascript* directory will be copied to the *Rails.root/public/javascripts/* directory. 

Moreover a *gmaps_api_key.yml* file will also be created in the *RAILS_ROOT/config/* folder. If this file already exists (installed for example by a previous version of the plugin), nothing will be done to it, so you can keep your configuration data even after updating the plugin. This file is a YAML representation of a hash, similar to the *database.yml* file in that the primary keys in the file are the different environments (development, test, production), since you will probably need to have different Google Maps API keys depending on that criteria (for example: a key for localhost for development and test; a key for your host for production). If you don't have any special need, there will be only one key associated with each environment. If however, you need to have multiple keys (for example if your app will be accessible from multiple URLs, for which you need different keys), you can also associate a hash to the environment, whose keys will be the different hosts. In this case, you will need to pass a value to the *:host* key when calling the method *GMap.header* (usually *@request.host*).


## Migration from the YM4R gem versions <= 0.4.1
Apart from the installation of the plugin detailed above, you will also need to delete the instructions to require the file and include the Ym4r::GoogleMaps module in your controllers:
	require 'ym4r'
	include Ym4r::GoogleMaps
This lines are now not needed since the plugin is loaded as part of the normal Rails loading procedure and the module is included when the plugin is loaded.


## Operations
You can use the library to display Google maps easily from Rails. The version of the API used is v2. The library is engineered so updates to the map through RJS/Ajax are possible. I have made available 2 in-depth tutorials to show some of the functionalities of the library and how it can be integrated with GeoRuby and the Spatial Adapter for Rails:

* http://thepochisuperstarmegashow.com/2006/06/02/ym4r-georuby-spatial-adapter-demo/
* http://thepochisuperstarmegashow.com/2006/06/03/google-maps-yahoo-traffic-mash-up/

Following is some notes about manipulating Google Maps with the library:


### Naming conventions
The names of the Ruby class follow the ones in the JavaScript Google Maps API v2, except for GMap2, which in Ruby code is called simply GMap. To know what is possible to do with each class, you should refer to the documentation available on Google website.

On top of that, you have some convenience methods for initializing the map (in the GMap class). Also, the constructors of some classes accept different types of arguments to be converted later in the correct JavaScript format. For example, the +GMarker+ aclass accepts an array of 2 floats as parameter, in addition of a GLatLng object, to indicate its position. It also facilitates the attribution of an HTML info window, displayed when the user clicks on it, since you can pass to the constructor an options hash with the *:info_window* key and the text to display as the value, instead of having to wire the response to a click event yourself.

### Binding JavaScript and Ruby
Since the Google Maps API uses JavaScript to create and manipulate a map, most of what the library does is outputting JavaScript, although some convenience methods are provided to simplify some common operations at initialization time. When you create a YM4R mapping object (a Ruby object which includes the MappingObject module) and call methods on it, these calls are converted by the library into JavaScript code. At initialization time, you can pass arbitrary JavaScript code to the *GMap#record_init* and *GMap#record_global_init*.Then, at update time, if you use Ruby-on-Rails as your web framework, you can update your map through RJS by passing the result of the method calls to the *page << * method to have it then interpreted by the browser.

For example, here is a typical initialization sequence for a map

>	@map = GMap.new("map_div")
>	@map.control_init(:large_map => true,:map_type => true)
>	@map.center_zoom_init([35.12313,-110.567],12)
>	@map.overlay_init GMarker.new([35.12878, -110.578],:title => "Hello!")
>	@map.record_init @map.add_overlay(GMarker.new([35.12878, -110.578],:title => "Hello!"))

While *center_zoom_init*, *control_init* or *overlay_init* (and generally all the GMap methods which end in *init*) are one of the rare convenience methods that do not output JavaScript, the *add_overlay* does. Actually, if you look at the code of the GMap class, you won't find any +add_overlay+ method, although in the documentation of the GMap2 class from the Google Maps API documentation, you will find something about the +addOverlay+ JavaScript method. In fact, when you call on a mapping object an unknow method, it is converted to a javascriptified version of it, along with its arguments, and a string of JavaScript code is output. So the *@map.add_overlay...* above is converted to *"map.addOverlay(new GMarker(GLatLng.new(35.12878, -110.578),{title:\"Hello!\"}))"*, which is then passed to the +record_init+ method of a Ruby GMap object to be later output along with the rest of the initialization code. Any arbitrary JavaScript code can be passed to the +record_init+ method. Note that 2 last lines of the previous code sample are strictly equivalent and since the +overlay_init+ version is a bit simpler, it should be preferred.


### Initialization of the map
The map is represented by a GMap object. You need to pass to the constructor the id of a DIV that will contain the map. You have to place this DIV yourself in your HTML template. You can also optionnally pass to the constructor the JavaScript name of the variable that will reference the map, which by default will be global in JavaScript. You have convenience methods to setup the controls, the center, the zoom, overlays, the interface configuration (continuous zoom, double click zoom, dragging), map types and the icons (which are also global). You can also pass arbitrary JavaScript to +record_init+ and +record_global_init+. Since, by default, the initialization of the map is performed in a callback function, if you want to have a globally accessible variable, you need to use the +global+ version.

You can also have multiple maps. Just make sure you give them different DIV id's, as well as different global variable names, when constructing them:

>	@map1 = GMap("map1_div","map1")
>	@map2 = GMap("map2_div","map2")

The other absolutely necessary initialization step in the controller is the setting of center and zoom:

>	@map1.center_zoom_init([49.12,-56.453],3)

Without this code the map will display an empty grey rectangle with Google's logo. 

Then in your template, you have 2 necessary calls:

* The static *GMap.header*: Outputs the inclusion of the JavaScript file from Google to make use of the Google Maps API and by default a style declaration for VML objects, necessary to display polylines under IE. This default can be overriddent by passing *:with_vml => false* as option to the +header+ method. You can also pass to this method a *:host* option in order to select the correct key for the location where your app is currently deployed, in case the current environment has multiple possible keys. Usually, in this case, you should pass it *@request.host*. Finally you can override all the key settings in the configuration by passing a value to the *:key* key.

* *GMap#to_html*: Outputs the initialization code of the map. By default, it outputs the +script+ tags and initializes the map in response to the onload event of the JavaScript window object. You can call +to_html+ on each one of your maps to have them all initialized. You can pass the option *:full=>true* to the method to setup a fullscreen map, which will also be resized when the window size changes.

You can also use *GMap#div* to output the div element with the correct +id+. You can pass it options *:height* and *:width* to set the size of the div (although, as indicated below, you have other ways to do that).

So you should have something like the following:
>	<html><head><title>Hello</title>
>	<%= raw(GMap.header) %>
>	<%= raw(@map.to_html) %>
>	</head>
>	<body><%= raw(@map.div(:width => 600,:height => 400)) %></body>
>	</html>

**Note that you need to set a size for the map DIV element at some point or the map will not be displayed.** You have a few ways to do this:

* You define it yourself, wherever you want. Usually as part of the layout definition in an external CSS.
* In the head of the document, through a CSS instruction output by *@map.header_width_height*, to which you pass 2 arguments (width and height).
* When outputting the DIV with *@map.div*, you can also pass an option hash, with keys *:width* and *:height* and a style attribute for the DIV element will be output.

### GMarkers
GMarkers are point of interests on a map. You can give a position to a GMarker constructor either by passing it a 2D-array of coordinates, a GLatLng object, an object of type Variable (which evaluates to a GLatLng when interpreted in the browser) or an address, which will be geocoded when the marker is initialized by the map.

You can pass options to the GMarker to customize the info window (*:info_window* or *:info_window_tabs* options), the tooltip (*:title* option) or the icon used (*:icon* option).

For example:
>	GMarker.new([12.4,65.6],:info_window => "**I'm a Popup window**",:title => "Tooltip")
>	GMarker.new(GLatLng.new([12.3,45.6]))
>	GMarker.new("Rue Clovis Paris France", :title => "geocoded")
	

### Update of the map
You are able to update the map through Ajax. In Ruby-on-Rails, you have something called RJS, which sends JavaScript created on the server as a response to an action, which is later interpreted by the browser. It is usually used for visual effects and replacing or adding elements. It can also accept arbitrary JavaScript and this is what YM4R uses.

For example, if you want to add a marker to the map, you need to do a few things. First, you have to bind a Ruby mapping object to the global JavaScript map variable. By default its name is +map+, but you could have overriden that at initialization time. You need to do something like this:

>	@map = Variable.new("map")

*map* in the Variable constructor is the name of the global JavaScript map variable. Then any method you call on *@map* will be converted in JavaScript to a method called on +map+. In your RJS code, you would do something like this to add a marker:

>	page << raw(@map.add_overlay(GMarker.new([12.1,12.76],:title => "Hello again!")))
	
What is sent to the browser will be the fllowing JavaScript code:

>	map.addOverlay(new GMarker(new GLatLng(123123.1,12313.76),{title:\"Hello again!\"}))


### GPolyline
GPolylines are colored lines on the map. The constructor takes as argument a list of GLatLng or a list of 2-element arrays, which will be transformed into GLatLng for you. It can also take the color (in the *#rrggbb* form), the weight (an integer) and the opacity. These arguments are optional though.

For example:
>	GPolyline.new([[12.4,65.6],[4.5,61.2]],"#ff0000",3,1.0)

Then you add it like any other overlay:
>	@map.overlay_init(polyline)

### GPolygon
GPolygons are colored areas on the map. As of 29/12, this feature is not documented in the official GMaps API, but thanks to Steven Talcott Smith (http://www.talcottsystems.com), it is possible to use it now in ym4r. 

The constructor takes as argument a list of GLatLng or a list of 2-element arrays, which will be transformed into GLatLng for you. Note that for polygons, the last point must be equal to the first, in order to have a closed loop. It can also take the color (in the *#rrggbb* form) of the stroke, the weight of the stroke, the opacity of the stroke, as well as the color of the fill and the opacity. These arguments are optional though.

For example:

>	GPolygon.new([[12.4,6.6],[4.5,1.2],[-5.6,-12.4],[12.4,6.6]],"#ff0000",3,1.0,"#00ff00",1.0)

Then you add it like any other overlay:

>	@map.overlay_init(polygon)
	
### GMarkerGroup
A new type of GOverlay is available, called GMarkerGroup. 

**To use it you would have to include in your HTML template the JavaScript file *markerGroup.js* after the call to *GMap.header* (because it extends the GOverlay class).** You should have something like that in your template:

>	<%= javascript_include_tag("markerGroup") %>

It is useful in 2 situations:

* Display and undisplay a group of markers without referencing all of them. You just declare your marker group globally and call +activate+ and +deactivate+ on this group in response, for example, to clicks on links on your page.

* Keeping an index of markers, for example, in order to show one of these markers in reponse to a click on a link (the way Google Local does with the results of the search).

Here is how you would use it from your Ruby code:

>	@map = GMap.new("map_div")
>	marker1 = GMarker.new([123.55,123.988],:info_window => "Hello from 1!")
>	marker2 = GMarker.new([87.123,18.9],:info_window =>"Hello from 2!")
>	@map.overlay_global_init(GMarkerGroup.new(true, 1 => marker1, 2 => marker2),"myGroup")

Here I have created an active (ie which is going to be displayed when the map is created) marker group called *myGroup* with 2 markers, which I want to reference later. If I did not want to reference them later (I just want to be able to display and undisplay the marker group), I could have passed an array instead of the hash.

Then in your template, you could have that:

>	... onclick="myGroup.showMarker(1);return false;"
>	... onclick="myGroup.showMarker(2);return false;"
>	<%= @map.div %>

When you click on one of the links, the corresponding marker has its info window displayed.

You can call *activate* and *deactivate* to display or undisplay a group of markers. You can add new markers with *addMarker(marker,id)*. Again if you don't care about referencing the marker, you don't need to pass an id. If the marker group is active, the newly added marker will be displayed immediately. Otherwise it will be displayed the next time the group is activated. Finally, since it is an overlay, the group will be removed when calling clearOverlays on the GMap object.

You can center and zoom on all the markers in the group by calling *GMarkerGroup#centerAndZoomOnMarkers()* after the group has been added to a map. So for example, if you would want to do that at initalization time, you would do the following (assuming your marker group has been declared as *group*):
	@map.record_init group.center_and_zoom_on_markers

### GMarkerManager
It is a recent (v2.67) GMaps API class that manages the efficient display of potentially thousands of markers. It is similar to the Clusterer (see below) since markers start appearing at specified zoom levels. The clustering behaviour has to be managed explicitly though by specifying the cluster for smaller zoom levels and specify the expanded cluster for larger zoom levels and so on. Note that it is not an overlay and is not added to the map through an overlay_init call.

Here is an example of use:
>    @map = GMap.new("map_div")
>    @map.control_init(:large_map => true, :map_type => true)
>    @map.center_zoom_init([59.91106, 10.72223],3)
>    srand 1234
>    markers1 = []
>    1.upto(20) do  |i|
>      markers1 << GMarker.new([59.91106 + 6 * rand - 3, 10.72223 + 6 * rand - 3],:title => "OY-20-#{i}")
>    end
>    managed_markers1 = ManagedMarker.new(markers1,0,7)
>
>    markers2 = []
>    1.upto(200) do  |i|
>      markers2 << GMarker.new([59.91106 + 6 * rand - 3, 10.72223 + 6 * rand - 3],:title => "OY-200-#{i}")
>    end
>    managed_markers2 = ManagedMarker.new(markers2,8,9)
>
>    markers3 = []
>    1.upto(1000) do  |i|
>      markers3 << GMarker.new([59.91106 +  6 * rand - 3, 10.72223 + 6 * rand - 3],:title => "OY-300-#{i}")
>    end
>    managed_markers3= ManagedMarker.new(markers3,10)
>
>    mm = GMarkerManager.new(@map,:managed_markers => [managed_markers1,managed_markers2,managed_markers3])
>    @map.declare_init(mm,"mgr")

### Clusterer
A Clusterer is a type of overlay that contains a potentially very large group of markers. It is engineered so markers close to each other and undistinguishable from each other at some level of zoom, appear as only one marker on the map at that level of zoom. Therefore it is possible to have a very large number of markers on the map at the same time and not having the map crawl to a halt in order to display them. It has been slightly modified from Jef Poskanzer's original Clusterer2 code (see http://www.acme.com/javascript/ for the original version). The major difference with that version is that, in YM4R, the clusterer is a GOverlay and can therefore be added to the map with *map.addOverlay(clusterer)* and is cleared along with the rest of overlays when *map.clearOverlays()* is called.

**In order to use a clusterer, you should include in your template page the clusterer.js file after the call to *GMap.header* (because it extends the GOverlay class).** You should have something like that in your template:

>	<%= javascript_include_tag("clusterer") %>

To create a clusterer, you should first create an array of all the GMarkers that you want to include in the clusterer (you can still add more after the clusterer has been added to the map though). When GMarkers close together are grouped in one cluster (represented by another marker on the map) and the user clicks on the cluster marker, a list of markers in the cluster is displayed in the info windo with a description: By default it is equal to the +title+ of the markers (which is also displayed as a tooltip when hovering on the marker with the mouse). If you don't want that, you can also pass to the GMarker constructor a key-value pair with key *:description* to have a description different from the title. For example, here is how you would create a clusterer:

>	markers = [GMarker.new([37.8,-90.4819],:info_window => "Hello",:title => "HOYOYO"),
>                  GMarker.new([37.844,-90.47819],:info_window => "Namaste",:description => "Chopoto" , :title => "Ay"),
>		  GMarker.new([37.83,-90.456619],:info_window => "Bonjour",:title => "Third"),
>	]
>	clusterer = Clusterer.new(markers,:max_visible_markers => 2)
	
Of course, with only 3 markers, the whole clusterer thing is totally useless. Usually, using the clusterer starts being interesting with hundreds of markers. The options to pass the clusterer are:

* *:max_visible_markers*: Below this number of markers, no clustering is performed. Defaults to 150.
* *:grid_size*: The clusterer divides the visible area into a grid of this size. Defaults to 5.
* *:min_markers_per_cluster*: Below this number of markers a cluster is not formed. Defaults to 5.
* *:max_lines_per_info_box*: Number of lines to display in the info window displayed when a cluster is clicked on by the user. Defaults to 10.
* *:icon*: Icon to be used to mark a cluster. Defaults to G_DEFAULT_ICON (the classic red marker).

Then to add the clusterer to the map at initialization time, you proceed as with a classic overlay:
>	@map.overlay_init clusterer

To add new markers in RJS (if the clusterer has been declared globally with overlay_global_init), you should do this:
>	page << raw(clusterer.add_marker(marker,description))
In this case, the *:description* passed to the GMarker contructor will not be taken into account. Only the *description* passed in the call to +add_marker+ will.

### GeoRss Overlay
An group of markers taken from a Rss feed containing location information in the W3C basic geo (WGS83 lat/lon) vocabulary and in the Simple GeoRss format. See http://georss.org for more details. The support for GeoRss relies on the MGeoRSS library by Mikel Maron (http://brainoff.com/gmaps/mgeorss.html), although a bit modified, mostly to have the GeoRssOverlay respect the GOverlay API. It has also been enhanced by Andrew Turner who added support for the GeoRss Simple format.

**Note that the *geoRssOverlay.js* file must be included in the HTML template in order to use this functionality.** You should have something like that in your template:
>	<%= javascript_include_tag("geoRssOverlay") %>

Here is how you would use it. First create the overlay at initialization:

>	def index
>	  @map = GMap.new("map_div")
>    	  @map.control_init(:large_map => true)
>    	  @map.center_zoom_init([38.134557,-95.537109],0)
>          @map.overlay_init(GeoRssOverlay.new(url_for(:action => "earthquake_rss"))
>	end

Since it is not possible to make requests outside the domain where the current page comes from, there is a need for a proxy. With the GeoRssOverlay initialization above, the request will be made by the *earthquake_rss* action, where the address to find the RSS feed will be hardwired:

>	def earthquake_rss
>           result = Net::HTTP.get_response("earthquake.usgs.gov","/eqcenter/recenteqsww/catalogs/eqs7day-M5.xml")
>           render :xml => result.body
>  	end

If you don't want to hardwire the RSS feed location in an action, you can. But you will have to pass the *:proxy* option to the GeoRssOverlay constructor. When requesting the RSS feed, the browser will in fact call the proxy with the actual URL of the RSS feed in the *q* parameter of the request. Here is how you would initialize the GeoRssOverlay that way:
>	@map.overlay_init(GeoRssOverlay.new("http://earthquake.usgs.gov/eqcenter/recenteqsww/catalogs/eqs7day-M5.xml",
>	:proxy => url_for(:action => "proxy")))
And here is an example of *proxy* action:
>	def proxy
>    	    result = Net::HTTP.get_response(URI.parse(@params[:q]))
>    	    render :xml => result.body
>  	end
You should probably do some checks to ensure the proxy is not abused but it is of your responsibility.

Another option can be passed to the GeoRssOverlay constructor to set an icon to be used by the markers of the overlay: *:icon*. By default it is equal to the default icon (the classic red one).

In the view, you should have something like the following:
>	<html>
>	<head><title>Testing GeoRss</title>
>	<%= raw(GMap.header(:with_vml => false)) %>
>	<%= raw(javascript_include_tag("geoRssOverlay")) %>
>	<%= raw(@map.header_width_height(600,400)) %>
>	<%= raw(@map.to_html) %>
>	</head>
>	<body>
>	<%= raw(@map.div) %>
>	</body>
>	</html> 
Note the inclusion of the *geoRssOverlay.js* file.

Other options to pass to the GeoRssOverlay constructor are the following:

- *:list_div*: In case you want to make a list of all the markers, with a link on which you can click in order to display the info on the marker, use this option to indicate the ID of the DIV (that you must place yourself on your page).
- *:list_item_class*: class of the DIV containing each item of the list. Ignored if option *:list_div* is not set.
- *:limit*: Maximum number of items to display on the map.
- *:content_div*: Instead of having an info window appear, indicates the ID of the DIV where this info should be displayed.

### Adding new map types
It is now possible to easily add new map types, on top of the already existing ones, like G_SATELLITE_MAP or G_NORMAL_MAP. The imagery for these new map types can come from layers of the standard map types or can be taken either from a WMS server or from pretiled images on a server (that can be generated with a tool that comes with the YM4R gem: refer to the README of the gem to know more about it). 

For example, here is how you would setup layers from a public WMS server of the DMAP team of the American Navy:

>	layer = WMSLayer.new("http://columbo.nrlssc.navy.mil/ogcwms/servlet/WMSServlet/AccuWeather_Maps.wms",
>	"20:3,6:3,0:27,0:29,6:19",
>	:copyright => {'prefix' => "Map Copyright 2006", 'copyright_texts'=> ["DMAP"]},
>	:use_geographic => true, :opacity => 0.8)
	
This sets up a connection to a WMS service, requesting layers *20:3,6:3,0:27,0:29,6:19* (you would have to look at the GetCapabilities document of the service to know what the valid layers are). The copyright notice attributes the data to DMAP. The images will be 80% opaque. For the rest of the options, the default values are used: default styles (*:style* option), PNG format (*:format* option), valid for all zoom levels (*:zoom_range* option). The option *:merc_proj* is irrelevant here since the *:use_geographic* option is true.

The arguments *:use_geographic* and *:merc_proj* warrant some explanation. The Google Maps are in the Simple Mercator projection in the WGS84 datum and currently do not support the display of data in projections other than that (at least if you want to display markers and lines on top of it). Unfortunately, different WMS servers do not identify this projection the same way. So you can give to the WMSLayer constructor your server type through the *:merc_proj* option  and it will figure out what is the correct identifier. Currently, this works only for *:mapserver* (EPSG:54004) and *:geoserver* (EPSG:41001). For others you can directly pass a number corresponding to the EPSG definition of the simple Mercator projection of your server. On top of that, some servers just don't support the Simple Mercator projection. This is why there is a *:use_geographic* option, that can be set to +true+. It is in order to tell the WMSLayer that it should request its tiles using LatLon coordinates in the WGS84 datum (which should be supported by any server in a consistant way). Unfortunately it is not perfect since the deformation is quite important for low zoom levels (< 5 for the US). Higher than that, the deformation is not that visible. However, if you control the WMS server, it is recommended that you don't use *:use_geographic* and instead use the *:merc_proj* option and setup the Mercator projection in your server if it is not done by default.

**Note that you need to include the *wms-gs.js* javascript file in your HTML page in order to make use of the WMSLayer functionality.** You should have something like that in your template:
	<%= javascript_include_tag("wms-gs") %>
This file uses code by John Deck with the participation of others (read the top of the javascript file to know more).

Here is how to define a pretiled layer:
>	layer = PreTiledLayer.new("http://localhost:3000/tiles",
>	:copyright => {'prefix' => "Map C 2006", 'copyright_texts' => ["Open Atlas"]},
>	:zoom_range => 13..13, :opacity => 0.7, :format => "gif")
I tell the PreTiledLayer constructor where I can find the tiles, setup the Copyright string, the valid zooms for the map, the opacity and the format. Tiles must have standardized names: *tile_#{zoom}_#{x_tile}_#{y_tile}.#{format}* (here the format is "gif"). You can use tools found in the YM4R gem to generate tiles in this format either from local maps or from WMS servers (useful to create tiles from geographic data files without having to run a map server or to cache images from slow servers). Again refer to the documentation of the gem for more information on how to do this.

Instead of having the tiles requested directly, you can also decide to have an action on the server which takes care of it. You can used the class PreTiledLayerFromAction for this. In this case, the first argument of the constructor is an url of an action. The arguments *x*, *y* and *z* will be passed to it.
>	layer = PreTiledLayerFromAction.new(url_for(:action => :get_tile),
>	:copyright => {'prefix' => "Map C 2006", 'copyright_texts' => ["Open Atlas"]},
>	:zoom_range => 13..14, :opacity => 0.7)
The other constructor arguments have the same meaning as PreTiledLayer. Here is an uninteresting example of action that serves tiles:
>	def get_tile
>         x = @params[:x]
>    	  y = @params[:y]
>    	  z = @params[:z]
>    	  begin
>            send_file "#{Rails.root}/public/tiles/tile_#{z}_#{x}_#{y}.png" , 
>		:type => 'image/png', :disposition => 'inline'
>          rescue Exception
>            render :nothing => true
>          end
>        end

You can add a layer to a new map type the following way:
>	map_type = GMapType.new(layer,"My WMS")
This is actually the simplest configuration possible. Your map type has only one data layer and is called "My WMS". You can add more that one layer: Either one that you have created yourself or existing ones. For example:
>	map_type = GMapType.new([GMapType::G_SATELLITE_MAP.get_tile_layers[0],layer,GMapType::G_HYBRID_MAP.get_tile_layers[1]],
>	"Test WMS")
Here for the "Test WMS" map type, we also take the first layer of the "Satellite" map type in the background and overlay the second layer of the "Hybrid" map type (roads, country boundaries, etc... transparently overlaid on top of the preceding layers) so when the "Test WMS" map type is selected in the interface, all three layers will be displayed.

Finally to add a map type to a GMap:
>	@map.add_map_type_init(map_type)
If you want to wipe out the existing map types (for example the 3 default ones), you can add a *false* argument to the *add_map_type_init* method and the +map_type+ will be the only one.

If you want to setup the map as the default one when the map is initially displayed, you should first declare the map type then add it to the map as indicated above and finally setting it as the default map type:
>	@map.declare_init(map_type,"my_map_type")
>	@map.add_map_type_init(map_type)
>	@map.set_map_type_init(map_type)
Future versions of the plugin may simplify that.

###Google Geocoding
A helper to perform geocoding on the server side (in Ruby) is included. Here is an example of request:
>	results = Geocoding::get("Rue Clovis Paris")
You can also pass to the *get* method an options hash to manage the various API key options (see the section on *GMap.header* for details). *results* is an array of Geocoding::Placemark objects, with 2 additional attributes: *status* and *name*. You should check if *status* equals *Geocoding::GEO_SUCCESS* to know if the request has been successful. You can then access the various data elements.

Here is an example that will display a marker on Paris:
>	results = Geocoding::get("Rue Clovis Paris")
>	if results.status == Geocoding::GEO_SUCCESS
>		coord = results[0].latlon
>		@map.overlay_init(GMarker.new(coord,:info_window => "Rue Clovis Paris"))
>	end

You could also have performed the geocoding on the client side with the following code, which is functionnality equivalent to the code above:
>	GMarker.new("Rue Clovis Paris",:info_window => "Rue Clovis Paris")

### Local Search
Local Search control has been added to the map and control objects. There are two places you need to implement it to get it to work. This is because the local search control needs an additional library added to the import as well as the control added to the map.

In your controller, you add ':local_search => true' to the @map.control_init like this:
>@map = GMap.new("map_div")
>@map.control_init(:large_map => true, :map_type => true, :local_search => true)

And in your view, you pass ':local_search => true' to the GMap.header like this:
><%= GMap.header(:local_search => true) %>
><%= @map.to_html %>
><%= @map.div(:width => 600, :height => 400) %>

You can pass options to the control_init as well. They are:
>:anchor => [:bottom_left (default), :bottom_right, :top_left, :top_right] 
>:offset_width => 10 (default)
>:offset_height => 20 (default)
>:local_search_options => "{suppressZoomToBounds : true, 
>													resultList : google.maps.LocalSearch.RESULT_LIST_INLINE, 
>													suppressInitialResultSelection : true, 
>													searchFormHint : 'Local Search powered by Google', 
>													linkTarget : GSearch.LINK_TARGET_BLANK}"

So if you wanted the local search control to be at the bottom right of the map, 30 pixel in from the right and 20 pixels above the bottom and some local search options it would look like this:
>@map.control_init(:large_map => true, :map_type => true, :local_search => true, :anchor => :bottom_right, :offset_width => 30, >:offset_height => 20, :local_search_options => "{suppressZoomToBounds : true, resultList : google.maps.LocalSearch.RESULT_LIST_INLINE, >suppressInitialResultSelection : true, searchFormHint : 'Local Search powered by Google', linkTarget : GSearch.LINK_TARGET_BLANK}")

## Sensor
Google now requires the 'sensor' attribute in the GET API request. It is defaulted to 'false', but if you are writing an application for one of the new cellphones with GPS out there then you can enable it by using the following call:

> <%= GMap.header :sensor => true %>

## Recent changes
- 'sensor' added to GET URL per Google API Terms of Use. 'false' by default.
- Local Search overlay added. See above for implementation.
- GMarker can now be placed by address (in addition to coordinates). Some code to geocode the address when the marker is initialized is added
- Addition of a +center_zoom_on_points_init+ to center and zoom on a group of pixel
- In JS, addition of methods to GMap2 and GMarkerGroup to center and zoom on a group of points or markers (thanks to Glen Barnes)
- Support for easy setup of fullscreen maps

## TODO
- Add support for easy manipulation of external Google Maps-related libraries: Advanced tooltip manipulation (PdMarker),...
- Addition of all GeoRss vocabularies (with all features: polylines...) to the geoRssOverlay extension
- Tutorials

## Disclaimer
This software is not endorsed in any way by Google.

## Acknowledgement
The YM4R/GM plugin bundles JavaScript libraries from John Deck (WMS layers on Google Maps), Jef Poskanzer (Clusterer on Google Maps) and Mikel Maron (GeoRss on Google Maps).

## License
The YM4R/GM plugin is released under the MIT license. The *clusterer.js* file is redistributed with a different license (but still compatible with the MIT license). Check the top of the file in *PLUGIN_ROOT/javascript* to know more.

## Support
Any questions, enhancement proposals, bug notifications or corrections can be sent to mailto:guilhem.vellut+ym4r@gmail.com.
