Factory.define :message do |m|
  m.sender_id "1"
  m.subject "hi"
  m.body "hey"
  m.receiver_id "5"
  m.read true
  m.sender_flag true
  m.receiver_flag true
  m.system_message true
end