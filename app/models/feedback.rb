class Feedback < ActiveRecord::Base
  belongs_to :profile
  validates :name, :email, :message, :subject, :presence => true

  after_save :send_feedback_to_admin

  private

  def send_feedback_to_admin    
    rec_profile = Profile.admin_emails
    ArNotifier.feedback_mail(self.reload, rec_profile).deliver
  end
  
end