class Feedback < ActiveRecord::Base
  include Humanizer
  belongs_to :profile
  after_save :send_feedback_to_admin
  validates :name, :email, :message, :subject, :presence => true
  require_human_on :create, :unless => :bypass_humanizer? if Rails.env.production?

  private

  def send_feedback_to_admin
    rec_profile = Profile.admin_emails
    ArNotifier.delay.feedback_mail(self.reload, rec_profile)
  end

  def bypass_humanizer?
    false
  end

end