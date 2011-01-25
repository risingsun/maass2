class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable

  has_one :profile
  SEX = ["Male","Female"]
  GROUP=["Teacher","Guest"]+(1992..Date.today.year+1).to_a
  EDU_YEAR=(1990..Date.today.year+5).to_a

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :email, :password, :password_confirmation, :remember_me, :login_name, :first_name, :last_name, :middle_name, :maiden_last_name, :gender, :groups
  validates :login_name, :presence => true,
                         :length   => { :maximum => 20 },
                         :uniqueness => true
  validates :first_name, :presence => true,
                         :length   => { :maximum => 20 }
  validates :last_name, :length   => { :maximum => 20 }
  validates :middle_name, :length   => { :maximum => 20 }
  validates :maiden_last_name, :length   => { :maximum => 20 }
end
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
#  groups               :string(255)
#  gender               :string(255)
#  question             :string(255)
#

