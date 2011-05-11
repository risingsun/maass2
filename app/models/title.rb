class Title < ActiveRecord::Base

  validates :name, :uniqueness => true
  before_save :name_titlecase

  def self.find_titles
    order("name").all
  end

  def name_titlecase
    name = name.titleize
  end

end