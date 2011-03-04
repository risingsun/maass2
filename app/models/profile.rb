class Profile < ActiveRecord::Base
  belongs_to :user

  attr_protected :is_active

  has_many :educations, :dependent => :destroy
  has_many :works, :dependent => :destroy
  has_many :permissions, :dependent => :destroy, :attributes => true
  has_many :blogs
  has_many :messages
  has_many :comments
  has_one :marker
  has_one :notification_control
  has_many :polls, :dependent => :destroy
  has_many :poll_responses, :dependent => :destroy

  has_many :friendships, :class_name  => "Friend", :foreign_key => 'inviter_id', :conditions => "status = #{Friend::ACCEPT_FRIEND}"
  has_many :follower_friends, :class_name => "Friend", :foreign_key => "invited_id", :conditions => "status = #{Friend::PENDING_FRIEND}"
  has_many :following_friends, :class_name => "Friend", :foreign_key => "inviter_id", :conditions => "status = #{Friend::PENDING_FRIEND}"

  has_many :friends,   :through => :friendships, :source => :invited
  has_many :followers, :through => :follower_friends, :source => :inviter
  has_many :followings, :through => :following_friends, :source => :invited

  has_many :sent_messages, :class_name => 'Message', :order => 'created_at desc', :foreign_key => 'sender_id', :conditions => "sender_flag = #{true} and system_message = #{false}"
  has_many :received_messages, :class_name => 'Message', :order => 'created_at desc', :foreign_key => 'receiver_id', :conditions => "receiver_flag = #{true}"
  has_many :unread_messages, :class_name => 'Message', :conditions => ["messages.read = #{false}"], :foreign_key => 'receiver_id'

  accepts_nested_attributes_for :notification_control
  accepts_nested_attributes_for :blogs
  accepts_nested_attributes_for :messages
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :marker
  accepts_nested_attributes_for :permissions
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

  scope :group, lambda{|y| {:conditions => ["profiles.group = ?",y]}}
  scope :active, :conditions => {:is_active => true}
  
  @@days = ()

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

  def check_friend(user, friend)
    Friend.find_by_inviter_id_and_invited_id(user, friend)
  end

  def start_following(friend)
    user.profile.following_friends.create(:invited_id => friend)
  end

  def stop_following(friend)
    if !check_friend(user.profile.id, friend).blank?
      Friend.destroy(check_friend(user.profile.id, friend))
    end
    if !check_friend(friend, user.profile.id).blank?
      Friend.destroy(check_friend(friend, user.profile.id))
    end
  end

  def make_friend(friend)
    user.profile.follower_friends.where(:inviter_id =>friend )[0].update_attribute(:status, Friend::ACCEPT_FRIEND)
    user.profile.friendships.create(:invited_id => friend, :status => Friend::ACCEPT_FRIEND)
  end

  def friend_of? user
    unless self.friends.where(:id=>user.profile.id).blank?
      return true
    end
  end

  def all_friends
    @my_friends ||= (self.followings+self.friends+[self]).uniq.compact 
  end

  def message_count
    self.received_messages.count if self.received_messages.count != 0
  end

  def profile_permissions
    if @permission_objects.nil?
      @permission_objects = []
      dbp = db_permissions
      @permission_objects = PERMISSION_FIELDS.map do |f|
        dbp[f].nil? ? permissions.build(:permission_field => f, :permission_type => default_permission) : dbp[f]
      end
    end
    @permission_objects
  end

  def db_permissions
    if @db_permissions.nil? && !permissions.nil?
      @db_permissions = Hash.new
      permissions.each { |p| @db_permissions[p.permission_field] = p }
    end
    @db_permissions
  end

  def field_permissions
    
    if @field_permissions.nil?
      @field_permissions = Hash.new
      dbp = db_permissions
      PERMISSION_FIELDS.each do |f|
        @field_permissions[f] = dbp[f].nil? ? default_permission.to_sym : dbp[f].permission_type.to_sym
      end
    end
    return @field_permissions
  end

  def can_see_field(field, profile)
    return false if self.send(field).blank?
    return true if profile == self
    permissions =  field_permissions
    permission = permissions[field]
    return true if permission.nil?
    if permission == :Everyone
      return true
    elsif permission == :Myself
      return false
    else permission == :Friends
      return friend_of?(profile.user)
    end
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

  private

  before_update :permission_sync

  def permission_sync
    return true if permissions.nil?
    permissions.delete permissions.select {|p| p.permission_type == default_permission}
  end

end