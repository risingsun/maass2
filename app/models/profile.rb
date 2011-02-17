class Profile < ActiveRecord::Base



 belongs_to :user
 has_many :educations, :dependent => :destroy
 has_many :works, :dependent => :destroy
 has_many :permissions, :dependent => :destroy, :attributes => true
 has_many :blogs
 has_one :marker
 has_one :notification

 has_many :polls, :dependent => :destroy
 has_many :poll_responses, :dependent => :destroy

 has_many :accepted_friends, :class_name  => "Friend", :foreign_key => 'inviter_id', :conditions => "status = 'accepted'"
 has_many :waiting_friends, :class_name  => "Friend", :foreign_key => 'inviter_id', :conditions => "status = 'requested'"
 has_many :friends, :through => :friendships, :source => :invited

 accepts_nested_attributes_for :notification
 accepts_nested_attributes_for :blogs
 accepts_nested_attributes_for :user
 accepts_nested_attributes_for :marker
 accepts_nested_attributes_for :permissions
 accepts_nested_attributes_for :educations, :allow_destroy => true,
                               :reject_if => proc { |attrs| reject = %w(education_from_year education_fo_year institution).all?{|a| attrs[a].blank?} }
 accepts_nested_attributes_for :works, :allow_destroy => true,
                               :reject_if => proc { |attrs| reject = %w(occupation industry company_name company_website job_description).all?{|a| attrs[a].blank?} }
 has_attached_file :icon, :styles => { :medium => "300x300>", :thumb => "100x100>" }

#  attr_accessible :first_name, :last_name, :middle_name, :maiden_name, :gender, :group
#  validates :first_name, :presence => true,
#                         :length => { :maximum => 20 }
#  validates :middle_name, :length => { :maximum => 20 }
#  validates :last_name, :length => { :maximum => 20 }
#  validates :maiden_name, :length => { :maximum => 20 }
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

  private

  before_update :permission_sync

  def permission_sync
    return true if permissions.nil?
    permissions.delete permissions.select {|p| p.permission_type == default_permission}

  end


end