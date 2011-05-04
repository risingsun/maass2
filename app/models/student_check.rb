class StudentCheck < ActiveRecord::Base

  belongs_to :profile

  alias_attribute :house, :house_name
  alias_attribute :examrollno,  :roll_no
  alias_attribute :rollno, :roll_no
  alias_attribute :enrollno,  :enroll_no
  alias_attribute :occu, :f_desg
  alias_attribute :date_of_birth, :birth_date
  alias_attribute :email_1, :e_mail_1
  alias_attribute :email_2, :e_mail_2

  validates :name, :presence=>true
  validates :year, :presence=>true
  
  before_save :titlecase_fields, :split_name
  before_validation :fix_name

  scope :year, lambda{|y| {:conditions => {:year => y}}}
  scope :unregistered, :conditions => ["profile_id is null"]
  scope :name_order, :order => 'first_name, last_name'
  scope :ordered, lambda { |*order| { :order => order.flatten.first}}
  scope :with_profile, :include => :profile  

  def titlecase_fields
    %w[ name first_name middle_name last_name].each do |attribute|
      if (attribute_present?(attribute) and !self[attribute].blank?)
        self[attribute] = self[attribute].strip.titlecase
      end
    end
    true
  end

  def split_name
    if first_name.blank? 
      names = self.name.split(" ") 
      self.first_name = names.shift 
      self.last_name = names.pop 
      self.middle_name = names.join(" ") 
    end 
    true
  end 
  
  def fix_name
    if self.name.blank?
      self.name = self.full_name
    end
  end

  def self.match_details?(profile,update=true)
    return true if DISABLE_STUDENT_CHECKING
    student = StudentCheck.where(["first_name like ? and last_name like ? and student_checks.year = ? and (profile_id is null or profile_id = ?)" ,
        profile.first_name, profile.premarital_lastname, profile.group, profile]).first
    if student
      if update
        student.update_attribute('profile',profile)
      end
      return true
    end
    return false
  end

  def self.unregistered_batch_members(year)
    year(year).unregistered.name_order.all
  end

  def self.unregistered_batch_count
    details = unregistered.all(:group => 'student_checks.year', :order => 'student_checks.year', :select => 'student_checks.year, count(*) as count')
    details_hash = {}
    details.each {|p| details_hash[p.year] = p.count.to_i}
    details_hash
  end

  def full_name
    [first_name,middle_name,last_name].reject(&:blank?).compact.join(" ").titlecase
  end

  def emails
    @emails ||= [email_1,email_2].reject(&:blank?).map(&:strip).uniq
  end

  def self.with_emails
    self.all(:conditions => "e_mail_1 != '' or e_mail_2 != ''")
  end

  def self.get_students(options)
    scope = StudentCheck.scoped({})
    scope = scope.ordered("student_checks.year,student_checks.first_name,student_checks.last_name")
    scope = scope.with_profile
    scope = scope.year(options[:year]) unless options[:year].blank?
    scope = scope.all unless options[:all].blank?
    scope
  end

  def self.alpha_index
    all(:select => 'name').map{|n| [n.name]}.flatten.compact.map{|x|x.strip.first.upcase}.uniq.sort
  end

end