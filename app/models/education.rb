class Education < ActiveRecord::Base
 belongs_to :profile
   
 validates_format_of :education_from_year, :education_to_year, :with => /^\d\d\d\d$/,
                      :message => 'Invalid Year', :allow_blank => :true

  end
