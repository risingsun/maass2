class User < ActiveRecord::Base

  #  after_create :build_profile

  include Humanizer
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :email, :password, :password_confirmation, :remember_me, :login,
    :first_referral_person_name, :first_referral_person_year,
    :second_referral_person_name, :second_referral_person_year,
    :third_referral_person_name,:third_referral_person_year,
    :additional_message, :profile_attributes
  attr_accessible :humanizer_answer, :humanizer_question_id
  require_human_on :create

  validates :login, :presence => true,
    :length => { :maximum => 20 },
    :uniqueness => true

  validates :requested_new_email, :format=> {:with => /^([^@\s]{1}+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message=>'does not look like an email address.', :if => proc {|obj| !obj.requested_new_email.blank?}}

  has_one :profile
  has_many :authentications
  accepts_nested_attributes_for :profile

  def is_admin
    return true if self.admin == true
  end

  def generate_confirmation_hash!(secret_word = "pimpim")
    self.email_verification = Digest::SHA1.hexdigest(secret_word + DateTime.now.to_s)
  end

  def match_confirmation?(user_hash)
    (user_hash.to_s == self.email_verification)
  end

  def request_email_change!(new_email)
    self.errors.add( :requested_new_email, "Cannot be Blank") and
      return false if new_email.blank?
    self.requested_new_email = new_email
    self.generate_confirmation_hash!
    self.save
  end

  def check_authentication(type)
    self.authentications.where(:provider => type)
  end

  private

  #    def build_profile
  #      debugger
  #        self.build_user_profile
  #    end
  #    def build_profile
  #       self.build_user_profile
  #    end


end