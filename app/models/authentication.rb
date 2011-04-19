class Authentication < ActiveRecord::Base
  belongs_to :user
  validates :uid, :uniqueness => true
end
