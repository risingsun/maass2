 Rails.application.config.middleware.use OmniAuth::Builder do
   provider :twitter, 'uqb5tjFy0PhKut5RQCUg', 'wXEsnXE2EMJoL5YVVZQcvyAHGiOOSZVSyy8XpPnDYs'
   provider :facebook, '637f4df719673a6c390a367284e39fee', 'dc4130a022ccc7ac3ec0047eee4adf0d',{:scope =>'read_stream,publish_stream,offline_access,user_photos'}
   provider :linked_in, 'cWKTofwhrB16xzPxOTWsQ6DbImXT2UV-lzUctxoGmAr1D4UlHsG8XV7nGUNv_j_8', 'eS8qNy0prPL9iEDD2Y9PidcjnQSCPAD-Z0uPCExeVVybrogJOroDfbUB-hxP50m1'
   provider :OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => 'yahoo', :identifier => 'yahoo.com'
   provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :domain => 'gmail.com'
 end
