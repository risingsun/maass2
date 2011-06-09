class User < ActiveRecord::Base

  ROLES = ['admin', 'user']
  include Humanizer
  has_one :profile
  has_many :authentications
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :email, :password, :password_confirmation, :remember_me, :login,
    :first_referral_person_name, :first_referral_person_year,
    :second_referral_person_name, :second_referral_person_year,
    :third_referral_person_name, :third_referral_person_year,
    :additional_message, :profile_attributes, :humanizer_answer,
    :humanizer_question_id, :role, :terms_of_service
  
  require_human_on :create, :unless => :bypass_humanizer? if Rails.env.production?  
  after_update :active_user, :if => proc {|obj| obj.sign_in_count == 1 && !obj.profile.is_active}
  before_save :require_references
  after_create :set_role

  validates :login, :presence => true,
    :length => {:within => 3..25},
    :uniqueness => true,
    :format=> {:with => /^\w+$/i, :message=>"can only contain letters and numbers."}
  validates :terms_of_service, :acceptance => true
  validates :requested_new_email, :format=> {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}, :if => proc {|obj| !obj.requested_new_email.blank?}
  validates :password, :confirmation => true

  accepts_nested_attributes_for :profile

  def set_role
    if User.all.size == 1
      self.role = 'admin'
    else
      self.role = 'user'
    end
    self.save
  end
  
  def is_admin?
    self.role.eql?('admin')
  end

  def generate_confirmation_hash!
    self.confirmation_token = Digest::SHA1.hexdigest(login + DateTime.now.to_s)
  end

  def match_confirmation?(user_hash)
    (user_hash.to_s == self.confirmation_token)
  end

  def request_email_change!(new_email)
    self.errors.add( :requested_new_email, "Cannot be Blank") and
      return false if new_email.blank?
    self.requested_new_email = new_email
    self.generate_confirmation_hash!
    self.confirmation_sent_at= DateTime.now
    self.save
  end

  def check_authentication(type)
    self.authentications.where(:provider => type).first
  end

  def match_details
    StudentCheck.match_details?(self.profile, false)
  end

  def require_references
    if !profile.is_active && !match_details && [first_referral_person_name, first_referral_person_year,
        second_referral_person_name,second_referral_person_year,
        third_referral_person_name, third_referral_person_year, additional_message ].reject!(&:blank?).blank?
      errors.add_to_base("Hey! It seems our database from school is incomplete, or has a poor spelling of your name.
                  Do you mind giving us some references so we can activate you manually instead?")
      return false
    end
    return true
  end

  private

  def active_user
    profile.toggle!(:is_active)
  end
    
  def bypass_humanizer?
    false
  end
  
end