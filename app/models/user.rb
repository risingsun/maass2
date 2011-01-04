class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable

  SEX = ["Male","Female"]
  GROUP=["Teacher","Guest"]+(1992..Date.today.year+1).to_a

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :login_name, :first_name, :last_name, :maiden_last_name, :gender, :group, :question, :middle_name

  validates :login_name, :presence => true,
                         :length => { :maximum => 20 },
                         :uniqueness => true
  validates :first_name, :presence => true,
                         :length => { :maximum => 20 }
  validates :last_name, :length => { :maximum => 20 }
  validates :maiden_last_name, :length => { :maximum => 20 }
end