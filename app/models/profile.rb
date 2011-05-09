class Profile < ActiveRecord::Base

  include Friendship
  include InMessaging
  include Permissioning
  include UserFeeds

  belongs_to :user
  belongs_to :marker

  Profile::NOWHERE = 'Nowhere'

  attr_protected :is_active

  has_many :educations, :dependent => :destroy
  has_many :works, :dependent => :destroy
  has_many :blogs, :dependent => :destroy
  has_many :albums, :dependent => :destroy
  has_many :comments, :as => :commentable
  has_many :profile_events,:dependent => :destroy
  has_many :events, :through => :profile_events
  has_many :profile_comments, :class_name => "Comment"
  has_many :feedbacks
  has_one :notification_control
  has_many :polls, :dependent => :destroy
  has_many :poll_responses, :dependent => :destroy
  has_many :forum_posts, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :invitations
  has_one :student_check

  has_many :sent_blogs, :class_name => 'Blog', :order => 'created_at desc', :conditions => "is_sent = #{false}"

  has_one :nomination

  accepts_nested_attributes_for :notification_control
  accepts_nested_attributes_for :blogs
  accepts_nested_attributes_for :albums, :allow_destroy => true
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :marker
  accepts_nested_attributes_for :educations, :allow_destroy => true,
    :reject_if => proc { |attrs| reject = %w(education_from_year education_to_year institution).all?{|a| attrs[a].blank?} }
  accepts_nested_attributes_for :works, :allow_destroy => true, :reject_if => proc { |attrs| reject = %w(occupation industry company_name company_website job_description).all?{|a| attrs[a].blank?} }

  has_attached_file :icon,
    :styles =>
    {:big => "150x150#",
    :medium => "100x100#",
    :small =>"50x50#",
    :small_60 =>  "60x60#",
    :small_20 =>  "20x20#"
  }
  validates :first_name,:middle_name,:last_name,:maiden_name,:spouse_name,:professional_qualification, :length => { :maximum => 30 }
  validates :first_name, :last_name, :presence => true
  validates_attachment_content_type :icon, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  

  permissible_fields PERMISSION_FIELDS
  
  my_default_permission_field :default_permission

  scope :group, lambda{|y| {:conditions => ["profiles.group = ?",y]}}
  scope :group_batch, lambda{|y| {:conditions => ["profiles.group = ?",y]}}
  scope :active, :conditions => {:is_active => true}

  scope :name_ordered, :order => 'profiles.group, first_name, last_name'

  scope :new_joined, :order => 'created_at desc'

  cattr_accessor :featured_profile
  @@featured_profile = {:date => Date.today-4, :profile => nil}
  @@days = ()

  after_update :create_my_feed  

  define_index do
    indexes :first_name
    indexes :middle_name
    indexes :last_name
    indexes :location
    indexes :group
    indexes :blood_group
    indexes :email
    indexes :date_of_birth
    indexes :anniversary_date
    indexes :about_me
    indexes :relationship_status
    indexes :spouse_name
    indexes :maiden_name
    indexes :activities
    indexes :house_name
    indexes :professional_qualification
    indexes :address_line1
    indexes :address_line2
    indexes :city
    indexes :postal_code
    indexes :state
    indexes :country
    indexes :landline
    indexes :mobile
    indexes educations.education_from_year
    indexes educations.education_to_year
    indexes educations.institution
    indexes works.occupation
    indexes works.industry
    indexes works.company_name
    indexes works.company_website
    indexes works.job_description
  end

  def status
    is_active? ? 'activated' : 'deactivated'
  end

  def location
    return Profile::NOWHERE if attributes['location'].blank?
    attributes['location']
  end

  def has_wall_with profile
    return false if profile.blank?
    !Comment.between_profiles(self, profile).empty?
  end

  def self.todays_featured_profile
    unless featured_profile[:date] == Date.today
      featured_profile[:profile] = featured
      featured_profile[:date] = Date.today
    end
    featured_profile[:profile]
  end

  def self.featured
    unless @featured
      ids = connection.select_all("select id from profiles where is_active = true and about_me != ''")
      @featured = find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
    end
    @featured
  end

  def is_me?(another_profile)
    self == (another_profile.kind_of?(User) ? another_profile.profile : another_profile)
  end

  def self.happy_day(days=self.happy_day_range,profile=nil,f='date_of_birth')
    clause = "#{f} is not null and date_format(#{f},'%m%d') in (?)"
    if profile
      clause += " and id in(?)"
      conditions = [clause,days,profile.all_friends.map(&:id)]
    else
      conditions = [clause,days]
    end
    self.active.all(
      :select => "id,title,first_name,middle_name,last_name,profiles.group,#{f},default_permission" ,
      :conditions => conditions, :include => :permissions).group_by {|d| d.send(f).strftime("%m%d") }
  end

  def self.happy_day_range(options = {})
    unless @@days
      options = options.reverse_merge(:date => Date.today, :back => 5, :forward => 10)
      start_date = options[:date] - options[:back].days
      end_date = options[:date] + options[:forward].days
      @@days = (start_date .. end_date).to_a.map{|d| d.strftime("%m%d")}
    end
    @@days
  end

  def self.find_all_happy_days(profile = nil, options = {})
    ref_date = options[:date] || Date.today
    days = self.happy_day_range(options)
    today_index = days.index(ref_date.strftime("%m%d"))
    birthdays = self.happy_day(days,profile,'date_of_birth')
    anniversaries = self.happy_day(days,profile,'anniversary_date')
    happy_days = {}
    [birthdays.keys + anniversaries.keys].flatten.uniq.sort.each do |date|
      happy_days[date] = {}
      happy_days[date][:birthdays] = birthdays.keys.any?{|d| d == date} ? birthdays[date] : []
      happy_days[date][:anniversaries] = anniversaries.keys.any?{|d| d == date} ? anniversaries[date] : []
      happy_days[date][:from_today] = days.index(date) - today_index
    end
    happy_days = happy_days.sort{|a,b| a[1][:from_today] <=> b[1][:from_today] }
    return  happy_days
  end

  def self.active_profiles
    self.active.all
  end

  def female?
    gender.downcase == 'female'
  end

  def maiden_name
    self[:maiden_name].titlecase unless self[:maiden_name].blank?
  end

  def premarital_lastname
    (female? and !maiden_name.blank?) ? maiden_name : last_name
  end
  
  def self.new_member
    Profile.where(:is_active => true).limit(6).order('created_at DESC').all
  end

  def group_member
    Profile.where(:group => group, :is_active => true)
  end

  def f(tr=15, options={})
    full_name(options).truncate(tr)
  end

  def full_name(options={})    
    n = [(title if options[:is_long]),first_name,(middle_name unless options[:is_short]),last_name].reject(&:blank?).compact.join(' ').titleize
    if n.blank?
      n = user.login rescue 'Deleted user'
    end
    n
  end

  def self.batch_details(group, opts)
    Profile.active.group_batch(group).name_ordered.paginate(opts)
  end

  def self.get_batch_count
    active.all(:group => 'profiles.group', :order => 'profiles.group', :select => 'profiles.group, count(*) as count')
  end  

  def self.latest_in_batch(group)
    group(group).active.new_joined.first
  end

  def self.change_group(year)
    years = Profile.where(:group => year, :is_active => true)
    group = years.map{|p| [p.full_name(), p.id]}
    return group
  end

  def self.admins
    self.all(:conditions => ["users.admin = true"], :include => "user")
  end

  def self.admin_emails
    User.all(:conditions => ["users.admin = true"]).map(&:email)
  end


  def wants_email_notification?(type)
    self.notification_control && 
      (self.notification_control.send(type) == NotificationControl::EMAIL_BIT ||
        self.notification_control.send(type) == NotificationControl::ALL_NOTIFICATION )
  end

  def wants_message_notification?(type)
    self.notification_control &&
      (self.notification_control.send(type) == NotificationControl::INTERNAL_MESSAGE_BIT ||
        self.notification_control.send(type) == NotificationControl::ALL_NOTIFICATION)
  end

  def friends_on_google_map(profile)
    f = (self.friends + self.followers + self.followings).select {|p| p.can_see_field('marker', profile)}.insert(0,self)
    users  = f.select {|p| p.marker}
    return users
  end

  def spouse_name
    self[:spouse_name].titlecase unless self[:spouse_name].blank?
  end

  def self.birthdays
    return @birthdays if @birthdays
    conditions = ['date_of_birth is not null']
    @birthdays = find(:all,:conditions => conditions).group_by {|d| d.date_of_birth.month }
    @birthdays.keys.each do |key|
      @birthdays[key].sort!{|a,b| a.date_of_birth.strftime("%e%m%Y") <=> b.date_of_birth.strftime("%e%m%Y") }
    end
    @birthdays
  end

  def self.anniversaries
    return @anniversaries if @anniversaries
    conditions = ['anniversary_date is not null']
    @anniversaries = find(:all,:conditions => conditions).group_by {|d| d.anniversary_date.month }
    @anniversaries.keys.each do |key|
      @anniversaries[key].sort!{|a,b| a.anniversary_date.strftime("%e%m%Y") <=> b.anniversary_date.strftime("%e%m%Y") }
    end
    @anniversaries
  end

  def self.today_birthday
    @profiles = self.all(
      :conditions => ["month(date_of_birth) =? and day(date_of_birth) = ?",
        Date.today.month, Date.today.day])
  end

  def self.today_anniversary
    @profiles = self.all(
      :conditions => ["month(anniversary_date) =? and day(anniversary_date) = ?",
        Date.today.month, Date.today.day])
  end

  def birthdate_next
    nextb = nil
    current_year = Date.today.year
    unless date_of_birth.blank?
      year = date_of_birth.strftime("%m%d") < Date.today.strftime("%m%d") ? current_year + 1 : current_year
      nextb = Date.civil(year,date_of_birth.month,date_of_birth.day) rescue nil
    end
    nextb
  end

  def anniversary_next
    nexta = nil
    current_year = Date.today.year
    unless anniversary_date.blank?
      year = anniversary_date.strftime("%m%d") < Date.today.strftime("%m%d") ? current_year + 1 : current_year
      nexta = Date.civil(year,anniversary_date.month,anniversary_date.day) rescue nil
    end
    nexta
  end

  def to_ical_birthday_event
    unless date_of_birth.blank?
      summary = "#{full_name}'s birthday"
      description = "#{full_name} (#{group}) has their birthday today. They were born on #{date_of_birth.to_formatted_s(:long_ordinal)}."
      description += "\n Wish them on http://localhost:3000/profiles/#{self.id}"
      return ical_event(birthdate_next,summary,description,'Birthdays')
    end
  end

  def to_ical_anniversary_event
    unless anniversary_date.blank?
      summary = "#{full_name}'s anniversary"
      description = "#{full_name} (#{group}) has their anniversary today. They were married "
      description += ' to ' + spouse_name unless spouse_name.blank?
      description += " on #{anniversary_date.to_formatted_s(:long_ordinal)}."
      description += "\n Wish them on http://#{SITE}/profiles/#{self.id}"
      description.squeeze!(' ')
      return ical_event(anniversary_next,summary,description,'Anniversaries')
    end
  end

  private

  def ical_event(event_date,summary,description,category)
    return nil if event_date.blank?
    event = Icalendar::Event.new
    event.start = event_date.strftime("%Y%m%dT%H%M%S")
    event.duration = 'PT24H'
    event.summary = summary
    event.description = description
    event.add_category(category) if category
    event.add_recurrence_rule('FREQ=YEARLY')    
    return event
  end

  
end