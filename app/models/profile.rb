class Profile < ActiveRecord::Base

  belongs_to :user
  has_many :educations, :dependent => :destroy
  has_many :works, :dependent => :destroy
  has_many :permissions, :dependent => :destroy, :attributes => true
  has_many :blogs
  has_one :marker
  has_many :messages
  has_one :notification_control
  has_many :friends, :foreign_key => "inviter_id"
  has_many :polls, :dependent => :destroy
  has_many :poll_responses, :dependent => :destroy

  Friend::FRIENDS_STATUSES.each do |key,value|
    has_many "#{key}_friends".to_sym, :class_name => "Friend", :foreign_key => "invited_id", :conditions => {:status => value}
  end

  # has_many :accepted_friends, :class_name  => "Friend", :foreign_key => 'inviter_id', :conditions => "status = 'accepted'"
  # has_many :waiting_friends, :class_name  => "Friend", :foreign_key => 'inviter_id', :conditions => "status = 'requested'"
  # has_many :friends, :through => :friendships, :source => :invited

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
  has_attached_file :icon, :styles => { :medium => "300x300>", :thumb => "100x100>" }

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

  attr_accessor :search_by, :search_value
  
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

  def search_by_keyword(p)
    conditions=[]
    if p[:search_by] == "name"
      conditions = [" first_name LIKE ? OR last_name LIKE ? ","%#{p[:search_value]}%","%#{p[:search_value]}%"]
    elsif p[:search_by] == "location"
      conditions = [" location LIKE ?","%#{p[:search_value]}%" ]
    elsif p[:search_by] == "blood_group"
      conditions = [" blood_group LIKE ? ","%#{p[:search_value]}%"]
    elsif p[:search_by] == "phone"
      conditions = [" mobile LIKE ? OR landline LIKE ? ","%#{p[:search_value]}%","%#{p[:search_value]}%"]
    elsif p[:search_by] == "address"
      conditions = [" address_line1 LIKE ? OR address_line2 LIKE ? ","%#{p[:search_value]}%","%#{p[:search_value]}%"]
    end
    Profile.where(conditions).all
  end
   
  private

  before_update :permission_sync

  def permission_sync
    return true if permissions.nil?
    permissions.delete permissions.select {|p| p.permission_type == default_permission}
  end
  
end