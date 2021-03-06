class Title < ActiveRecord::Base

  validates :name, :uniqueness => true
  before_save :name_titlecase
  attr_accessible :id, :name
  
  def self.find_titles
    order("name").all
  end

  def name_titlecase    
    self.name= self.name.titleize
  end

end