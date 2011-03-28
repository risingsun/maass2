# == Schema Information
#
# Table name: users
#
#  id                   :integer(4)      not null, primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer(4)      default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  login_name           :string(255)
#  first_name           :string(255)
#  last_name            :string(255)
#  middle_name          :string(255)
#  maiden_last_name     :string(255)
#  group                :string(255)
#  gender               :string(255)
#  question             :string(255)

class User < ActiveRecord::Base

  #  after_create :build_profile

  include Humanizer
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :email, :password, :password_confirmation, :remember_me, :login
  attr_accessible :humanizer_answer, :humanizer_question_id
  require_human_on :create

  validates :login, :presence => true,
    :length => { :maximum => 20 },
    :uniqueness => true

  validates :requested_new_email, :format=> {:with => /^([^@\s]{1}+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message=>'does not look like an email address.', :if => proc {|obj| !obj.requested_new_email.blank?}}

  has_one :profile
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

  private

  #    def build_profile
  #      debugger
  #        self.build_user_profile
  #    end
  #    def build_profile
  #       self.build_user_profile
  #    end


end