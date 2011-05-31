require 'twitter'

module Twitter
  class Client
    class << self
      Twitter.configure do |config|
        config.consumer_key = 'uqb5tjFy0PhKut5RQCUg'
        config.consumer_secret = 'wXEsnXE2EMJoL5YVVZQcvyAHGiOOSZVSyy8XpPnDYs'
        config.oauth_token = '138735206-SJEzHximPFlHqIuM5dvCCtCwMemrieVZSqcah4gG'
        config.oauth_token_secret = 'N6buZTWCZyZQef5Z7iZurTOlQ4rcsW4LBQnyoFwTkmk'
      end
    end
  end
end