class Feedback < ActiveRecord::Base
 
  validates :name, :email, :message, :subject, :presence => true
  belongs_to :profile
  after_save :send_feedback_to_admin

  private

  def send_feedback_to_admin    
    rec_profile = Profile.admin_emails
    ArNotifier.delay.feedback_mail(self.reload, rec_profile)
  end
  
end