class NotificationControl < ActiveRecord::Base
  belongs_to :profile

  def self.set_value(notify)
    notify.each do |k,v|
      s=v.to_s
      case s
      when "em"
        notify[k]=1
      when "e"
        notify[k]=2
      when "m"
        notify[k]=3
      when ""
        notify[k]=0
      end
    end
    return notify
   end
   
end
