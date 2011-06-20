Factory.define :feed do |f|
  f.profile {|u| u.association(:profile)}
  f.feed_item {|u| u.association(:feed_item)}
end