class Profile < ActiveRecord::Base

  include Friendship
  include InMessaging
  include Permissioning
  include UserFeeds

  belongs_to :user

  Profile::NOWHERE = 'Nowhere'

  attr_protected :is_active

  has_many :educations, :dependent => :destroy
  has_many :works, :dependent => :destroy
  has_many :blogs
  has_many :comments
  has_many :profile_events,:dependent => :destroy
  has_many :events, :through => :profile_events
  has_many :photos
  has_many :profile_comments, :class_name => "Comment", :as => :commentable
  has_one :marker
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
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :marker
  accepts_nested_attributes_for :educations, :allow_destroy => true,
    :reject_if => proc { |attrs| reject = %w(education_from_year education_fo_year institution).all?{|a| attrs[a].blank?} }
  accepts_nested_attributes_for :works, :allow_destroy => true, :reject_if => proc { |attrs| reject = %w(occupation industry company_name company_website job_description).all?{|a| attrs[a].blank?} }

  has_attached_file :icon,
    :styles =>
    {:big => "150x150#",
    :medium => "100x100#",
    :small =>"50x50#",
    :small_60 =>  "60x60#",
    :small_20 =>  "20x20#"
  }
  validates_attachment_content_type :icon, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  permissible_fields PERMISSION_FIELDS
  
  my_default_permission_field :default_permission

  scope :group, lambda{|y| {:conditions => ["profiles.group = ?",y]}}
  scope :group_batch, lambda{|y| {:conditions => ["profiles.group = ?",y]}}
  scope :active, :conditions => {:is_active => true}

  scope :name_ordered, :order => 'profiles.group, first_name, last_name'

  scope :new_joined, :order => 'created_at desc'

  cattr_accessor :featured_profile
  @@featured_profile = {:date=>Date.today-4, :profile=>nil}
  @@days = ()

  after_update :create_my_feed

  #attr_accessor :key, :search[q]

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
  end

  def status
    is_active? ? 'activated' : 'deactivated'
  end

  def location
    return Profile::NOWHERE if attributes['location'].blank?
    attributes['location']
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

  def self.search_by_keyword(p)
    conditions=[]
    if p[:key] == "name"
      conditions = [" first_name LIKE ? OR last_name LIKE ? ","%#{p[:q]}%","%#{p[:q]}%"]
    elsif p[:key] == "location"
      conditions = [" location LIKE ?","%#{p[:q]}%" ]
    elsif p[:key] == "blood_group"
      conditions = [" blood_group LIKE ? ","%#{p[:q]}%"]
    elsif p[:key] == "year"
      conditions = [" profiles.group LIKE ? ","%#{p[:q]}%"]
    elsif p[:key] == "phone"
      conditions = [" mobile LIKE ? OR landline LIKE ? ","%#{p[:q]}%","%#{p[:q]}%"]
    elsif p[:key] == "address"
      conditions = [" address_line1 LIKE ? OR address_line2 LIKE ? ","%#{p[:q]}%","%#{p[:q]}%"]
    end
    Profile.where(conditions).all
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
  
  def gender_str
    gender.downcase
  end

  def batch_mates
    Profile.find()
  end

  def self.new_member
    Profile.find(:all, :conditions => {:is_active => true}, :limit => 6, :order => 'created_at DESC')
  end

  def group_member
    Profile.where(:group => group, :is_active => true)
  end

  def f(tr=15, options={})
    full_name(:length => tr)
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

  def self.batch_names(year)
    active.group_batch(year).name_ordered.all(:select => 'title,first_name, middle_name, last_name, id')
  end

  def self.get_batch_count
    active.all(:group => 'profiles.group', :order => 'profiles.group', :select => 'profiles.group, count(*) as count')
  end  

  def self.latest_in_batch(group)
    group(group).active.new_joined.first
  end

  def self.greetings(type)
    Profile.all(:conditions => ["#{type} is not NULL" ], :order => "#{type} ASC")
  end

  def admin_blogs
    self.blogs.all(:conditions => {:is_sent =>:false}, :order => "created_at DESC")
  end

  def admin_images(image)
    self.photos.all(:conditions => {:set_as_blurb => image})
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
    Profile.admins.map(&:email)
  end


  def wants_email_notification?(type)
    self.notification_control && (self.notification_control.send(type) == NotificationControl::EMAIL_BIT || self.notification_control.send(type) == NotificationControl::ALL_NOTIFICATION )
  end

  def wants_message_notification?(type)
    self.notification_control && (self.notification_control.send(type) == NotificationControl::INTERNAL_MESSAGE_BIT || self.notification_control.send(type) == NotificationControl::ALL_NOTIFICATION)
  end

  def friends_on_google_map(profile)
    f = (profile.friends + profile.followers + profile.followings).select {|p| p.can_see_field('marker', self)}
    friends = f.select {|p| p.marker}
    return friends
  end
  
end