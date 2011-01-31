class Profile < ActiveRecord::Base

 belongs_to :user
 has_many :educations, :dependent => :destroy
 has_many :works, :dependent => :destroy
 has_one :marker
 accepts_nested_attributes_for :user
 accepts_nested_attributes_for :marker


 accepts_nested_attributes_for :educations, :allow_destroy => true, :reject_if => proc { |attrs| reject = %w(education_from_year education_fo_year institution).all?{|a| attrs[a].blank?} }

 accepts_nested_attributes_for :works, :allow_destroy => true, :reject_if => proc { |attrs| reject = %w(occupation industry company_name company_website job_description).all?{|a| attrs[a].blank?} }

 has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }


 INDIA_STATES = [ "Andhra Pradesh",
   "Arunachal Pradesh",
   "Assam",
   "Andaman and Nicobar Islands",
   "Bihar",
   "Chandigarh",
  "Chhattisgarh",
   "Dadra and Nagar Haveli",
   "Daman and Diu",
   "Delhi",
   "Goa",
   "Gujarat",
   "Harayana",
   "Himachal Pradesh",
   "Jammu and Kashmir",
   "Jharkhand",
   "Karnataka",
   "Kerala",
   "Lakshadweep",
   "Madhya Pradesh",
   "Maharashtra",
   "Manipur",
   "Meghalaya",
   "Mizoram",
   "Nagaland",
   "Orissa",
   "Punjab",
   "Puducherry",
   "Rajasthan",
   "Sikkim",
   "Tamilnadu",
   "Tripura",
   "Uttarakhand",
   "Uttar Pradesh",
  "West Bengal"]

end
