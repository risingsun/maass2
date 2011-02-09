class Account < ActiveRecord::Base

  belongs_to :user
  has_one :permission
  has_one :notification
  accepts_nested_attributes_for :permission
  accepts_nested_attributes_for :notification
#  before_save :update_permission
#
#  def update_permission
#  User::PERMISSION_FIELDS.each do |x|
#   permission.update_attributes({x => self.default_permission})
#   end
#  end
end