 Rails.application.config.middleware.use OmniAuth::Builder do
   provider :twitter, 'uqb5tjFy0PhKut5RQCUg', 'wXEsnXE2EMJoL5YVVZQcvyAHGiOOSZVSyy8XpPnDYs'
   provider :facebook, '0afea3ef43845e21ff2d3c991954b3d2', '06d707dca86feddf20e85b68d639e6c6'
end