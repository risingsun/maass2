 Rails.application.config.middleware.use OmniAuth::Builder do
   provider :twitter, 'uqb5tjFy0PhKut5RQCUg', 'wXEsnXE2EMJoL5YVVZQcvyAHGiOOSZVSyy8XpPnDYs',{:scope =>'read_stream,publish_stream,offline_access,user_photos'}
   provider :facebook, '20fb2f1add6ab1d78dd20624250193bb', 'fcc3cca72b2eeded55558cfbb2135168'
   provider :linked_in, 'cWKTofwhrB16xzPxOTWsQ6DbImXT2UV-lzUctxoGmAr1D4UlHsG8XV7nGUNv_j_8', 'eS8qNy0prPL9iEDD2Y9PidcjnQSCPAD-Z0uPCExeVVybrogJOroDfbUB-hxP50m1'
   provider :OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => 'yahoo', :identifier => 'yahoo.com'
#   provider :OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
   provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :domain => 'gmail.com'
 end
