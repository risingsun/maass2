require 'spec_helper'

describe Poll do
  before(:each) do
    @poll ={ :question => "hi", :profile_id => "1", :public => "true", :votes_count => "1", :status => "hello" }
  end

  it "should require a question" do
    no_question = Poll.new(@poll.merge(:question => nil))
    no_question.should_not be_valid
  end

end
