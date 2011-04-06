class HouseName < ActiveRecord::Base

  validates :name, :uniqueness=>true
  before_save :name_titlecase

  def self.find_house_names
    HouseName.order("name").all
  end

  def name_titlecase
    self.name =self.name.titleize
  end
end