class Nomination < ActiveRecord::Base

  belongs_to :profile
  validates :profile, :contact_details, :occupational_details, :reason_for_nomination,:suggestions ,:presence => true
  validates :profile_id, :uniqueness => true

  after_save :send_mail_to_admin

  private

  def send_mail_to_admin
    rec_profile = Profile.admin_emails
    ArNotifier.delay.nomination_mail(self, rec_profile)
  end

end