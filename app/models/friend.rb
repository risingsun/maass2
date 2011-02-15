class Friend < ActiveRecord::Base

  FRIENDS_STATUSES = {"accepted" => "accept", "waiting" => "wait"}
  belongs_to :profile 

  FRIENDS_STATUSES.each do |key,value|
    scope key.to_sym, where(:status => value)
  end

end
