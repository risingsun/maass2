Factory.define(:announcement) do |a|
  a.message "Hello"
  a.starts_at DateTime.now
  a.ends_at DateTime.now + 2.months
end