class PollResponse < ActiveRecord::Base
  belongs_to :profile
  belongs_to :poll_option
  belongs_to :poll

  validates :profile,:poll_option,:poll, :presence => true
  #validates_uniqueness_of :profile_id, :scope => :poll_id

   after_save :update_poll_votes_count


  private

  def update_poll_votes_count
    count_poll_response
    votes_count = PollOption.sum(:poll_responses_count, :conditions => {:poll_id => self.poll_id})
    self.poll.votes_count = votes_count
    self.poll.save!
  end

  def count_poll_response
    self.poll_option.poll_responses_count += 1
    self.poll_option.save!
  end

end
