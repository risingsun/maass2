class Profile < ActiveRecord::Base

  belongs_to :user
  has_many :educations, :dependent => :destroy
  has_many :works, :dependent => :destroy
  has_many :permissions, :dependent => :destroy, :attributes => true
  has_many :blogs
  has_many :messages
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
  accepts_nested_attributes_for :works, :allow_destroy => true,
                             :reject_if => proc { |attrs| reject = %w(occupation industry company_name company_website job_description).all?{|a| attrs[a].blank?} }
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

  INDIA_STATES = [ "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Andaman and Nicobar Islands",
    "Bihar",
    "Chandigarh",
    "Chhattisgarh",
    "Dadra and Nagar Haveli",
    "Daman and Diu",
    "Delhi",
    "Goa",
    "Gujarat",
    "Harayana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Lakshadweep",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Orissa",
    "Punjab",
    "Puducherry",
    "Rajasthan",
    "Sikkim",
    "Tamilnadu",
    "Tripura",
    "Uttarakhand",
    "Uttar Pradesh",
    "West Bengal"]

#  attr_accessible :first_name, :last_name, :middle_name, :maiden_name, :gender, :group
#  validates :first_name, :presence => true,
#                         :length => { :maximum => 20 }
#  validates :middle_name, :length => { :maximum => 20 }
#  validates :last_name, :length => { :maximum => 20 }
#  validates :maiden_name, :length => { :maximum => 20 }


  attr_accessor :search_by, :search_value

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

  def profile_permissions
    if @permission_objects.nil?
      @permission_objects = []
      dbp = db_permissions
      @permission_objects = User::PERMISSION_FIELDS.map do |f|
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

  def gender_str
    gender.downcase
  end

  def self.new_member
    Profile.all
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