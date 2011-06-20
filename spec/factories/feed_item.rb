Factory.define :feed_item do |f|
  f.association :item, :factory => :blog
end