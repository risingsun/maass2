Factory.define :profile_event do |pe|
  pe.profile {|p| p.association(:profile)}
  pe.event {|e| e.association(:event)}
  pe.role "Organizer"
end