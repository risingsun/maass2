 Rails.application.config.middleware.use OmniAuth::Builder do
   provider :twitter, 'uqb5tjFy0PhKut5RQCUg', 'wXEsnXE2EMJoL5YVVZQcvyAHGiOOSZVSyy8XpPnDYs'
   provider :facebook, '0afea3ef43845e21ff2d3c991954b3d2', '06d707dca86feddf20e85b68d639e6c6'
   provider :linked_in, 'cWKTofwhrB16xzPxOTWsQ6DbImXT2UV-lzUctxoGmAr1D4UlHsG8XV7nGUNv_j_8', 'eS8qNy0prPL9iEDD2Y9PidcjnQSCPAD-Z0uPCExeVVybrogJOroDfbUB-hxP50m1'
#   provider :google_apps, OpenID::Store::Filesystem.new('/tmp')
   provider :OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => 'yahoo', :identifier => 'yahoo.com'
 end