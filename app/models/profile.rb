class Profile < ActiveRecord::Base

  belongs_to :user
  has_many :educations, :dependent => :destroy
  has_many :works, :dependent => :destroy
  has_many :blogs
  has_one :marker

  has_many :polls, :dependent => :destroy
  has_many :poll_responses, :dependent => :destroy

  has_many :friends, :foreign_key => "inviter_id"

  Friend::FRIENDS_STATUSES.each do |key,value|
    has_many "#{key}_friends".to_sym, :class_name => "Friend", :foreign_key => "invited_id", :conditions => {:status => value}
  end

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :blogs
  accepts_nested_attributes_for :marker
  accepts_nested_attributes_for :educations, :allow_destroy => true,
    :reject_if => proc { |attrs| %w(education_from_year education_fo_year institution).all?{|a| attrs[a].blank?} }
  accepts_nested_attributes_for :works, :allow_destroy => true,
    :reject_if => proc { |attrs| %w(occupation industry company_name company_website job_description).all?{|a| attrs[a].blank?} }
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }

end
