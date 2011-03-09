class Profile < ActiveRecord::Base

  include Friendship
  include InMessaging
  include Permissioning
  include UserFeeds

  belongs_to :user

  attr_protected :is_active

  has_many :educations, :dependent => :destroy
  has_many :works, :dependent => :destroy
  has_many :blogs
  has_many :comments
  has_many :profile_comments, :class_name => "Comment", :as => :commentable
  has_one :marker
  has_one :notification_control
  has_many :polls, :dependent => :destroy
  has_many :poll_responses, :dependent => :destroy

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
  scope :active, :conditions => {:is_active => true}

  @@days = ()

  after_update :create_my_feed

  attr_accessor :search_by, :search_value

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

  def is_me?(another_profile)
    self == (another_profile.kind_of?(User) ? another_profile.profile : another_profile)
  end

  def self.search_by_keyword(p)
    conditions=[]
    if p[:search_by] == "name"
      conditions = [" first_name LIKE ? OR last_name LIKE ? ","%#{p[:search_value]}%","%#{p[:search_value]}%"]
    elsif p[:search_by] == "location"
      conditions = [" location LIKE ?","%#{p[:search_value]}%" ]
    elsif p[:search_by] == "blood_group"
      conditions = [" blood_group LIKE ? ","%#{p[:search_value]}%"]
    elsif p[:search_by] == "year"
      conditions = [" profiles.group LIKE ? ","%#{p[:search_value]}%"]
    elsif p[:search_by] == "phone"
      conditions = [" mobile LIKE ? OR landline LIKE ? ","%#{p[:search_value]}%","%#{p[:search_value]}%"]
    elsif p[:search_by] == "address"
      conditions = [" address_line1 LIKE ? OR address_line2 LIKE ? ","%#{p[:search_value]}%","%#{p[:search_value]}%"]
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


  def gender_str
    gender.downcase
  end

  def self.new_member
    Profile.find(:all, :conditions => {:is_active => true}, :limit => 6, :order => 'created_at DESC')
  end

  def self.group_member(group)
    Profile.find(:all, :conditions => {:group => group}, :limit => 6)
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

end