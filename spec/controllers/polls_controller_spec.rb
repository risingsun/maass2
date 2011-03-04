require 'spec_helper'

describe PollsController do

  before :each do
    @p = {:question => "hi how r u all", :profile_id => "1", :public => false, :votes_count => 0, :status => true }
    @poll = Poll.new(@p)
    @poll.poll_options_attributes = {"0" =>{:option=>"fine"}}
    @poll.save!
  end

#  describe "GET 'index'" do
#    it "should be successful" do
#      get 'index'
#      assigns[:poll].should be_a_kind_of(Array)
#      assigns[:poll].should_not be_nil
#      assigns[:poll].should render_template('index')
#      response.should be_success
#    end
#  end
#
#  describe "GET 'new'" do
#    it "should be successful" do
#      get 'new'
#      assigns[:poll].should be_an_instance_of(Poll)
#      assigns[:poll].should be_a_new_record
#      assigns[:poll].should_not be_nil
#      response.should be_success
#    end
#  end

  describe "POST 'create'" do
    lambda do
      assigns[:poll].should be_an_instance_of(Poll)
      assigns[:poll].should be_a_new_record
      assigns[:poll].should_not be_nil
      assigns[:profile].should be_an_instance_of(Profile)
      assigns[:profile].should_not be_a_new_record
      assigns[:profile].should_not be_nil
      assigns[:profile].should render_template('index')
    end
    
    describe "failure" do
      before(:each) do
        @poll = { :question => "", :profile_id=> "", :status=> "",:public=>"", :votes_count=>"" }
      end

      it "should not create a poll" do
        lambda do
          get :create, :poll => @poll
          response.should_not change(Poll, :count).by(0)
        end
      end

      it "should have a failure message" do
        lambda do
          post :create, :poll => @poll
          flash[:notice].should =~ /Poll was not successfully created/
        end
      end

      it "should redirect to index page" do
        lambda do
          post :create, :poll => @poll
          assigns[:poll].should redirect_to :polls
        end
      end
    end

    describe "success" do
      before(:each) do
        @poll = {:question => "hi how r u all", :profile_id=> 1, :status=> true, :public=>false, :votes_count=>0}
      end

      it "should create a poll" do
        lambda do
          post :create, :poll => @poll
          response.should change(Poll, :count).by(0)
        end
      end

      it "should have a success message" do
        lambda do
          post :create, :poll => @poll
          flash[:notice].should =~ /Poll was successfully created/
        end
      end

      it "should render template new" do
        lambda do
          post :create, :poll => @poll
          assigns[:poll].should render_template('new')
        end
      end
    end
  end

end