class Account < ActiveRecord::Base

  belongs_to :user
  has_one :permission
  has_one :notification
  accepts_nested_attributes_for :permission
  accepts_nested_attributes_for :notification


end