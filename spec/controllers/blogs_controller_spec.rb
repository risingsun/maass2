require 'spec_helper'

describe BlogsController do

  before :each do
    @user = Factory(:user)
    sign_in(@user)
    @profile = Factory(:profile, :user => @user)
    @blog = Factory(:blog, :profile => @profile)
    @current_user = User.find_by_id!(@user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      Factory(:blog, :profile => @profile)
      get 'index'
      assigns[:blog].should be_a_kind_of(Array)
      assigns[:blog].should_not be_nil
      assigns[:blog].should render_template('index')
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      assigns[:blog].should be_an_instance_of(Blog)
      assigns[:blog].should be_a_new_record
      assigns[:blog].should_not be_nil
      assigns[:profile].should be_an_instance_of(Profile)
      assigns[:profile].should_not be_a_new_record
      assigns[:profile].should_not be_nil
      assigns[:profile].should render_template('new')
      response.should be_success
    end
  end

  describe "POST 'create'" do

    lambda do
     assigns[:blog].should be_an_instance_of(Blog)
     assigns[:blog].should_not be_a_new_record
     assigns[:blog].should_not be_nil
     assigns[:profile].should be_an_instance_of(Profile)
     assigns[:profile].should_not be_a_new_record
     assigns[:profile].should_not be_nil
    end

    describe "failure" do

        before(:each)do
          @blog = { :title => "", :body => ""}
        end

      it "should not create a blog" do
          lambda do
            get :create, :blog => @blog
            response.should_not change(Blog, :count)
          end
      end

      it "should have a failure message" do
        lambda do
          post :create, :blog => @blog
          flash[:notice].should =~ /Blog Creation Failed/
        end
      end

      it "should render template new" do
        lambda do
          post :create, :blog => @blog
          assigns[:blog].should render_template('new')
        end
      end
      
   end

   describe "success" do

      before(:each) do
        @attr = {:title => "kirti", :body=> "this is my first blog"}
      end

      it "should create a blog" do
        lambda do
          post :create, :blog => @body
        end.should change(Blog, :count).by(0)
      end

      it "should have a success message" do
        lambda do
          post :create, :blog => @blog
          flash[:notice].should =~ /Successfully created Blog/
        end
      end

      it "should redirect to index page" do
        lambda do
          post :create, :blog => @blog
          assigns[:blog].should redirect_to :blogs
        end
      end
      
    end
  end
  
  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :id => Factory(:blog, :profile => @profile)
      assigns[:blog].should be_an_instance_of(Blog)
      assigns[:blog].should_not be_new_record
      assigns[:blog].should render_template('edit')
      response.should be_success
    end
  end

  describe "SHOW 'show'" do
    it "should be successful" do
      get :show, :id => Factory(:blog, :profile => @profile)
      assigns[:blog].should be_an_instance_of(Blog)
      assigns[:blog].should_not be_new_record
      assigns[:blog].should render_template('show')
      response.should be_success
    end
  end

  describe "DELETE 'destroy'" do
    it "should be successful" do
      delete :destroy, :id => @blog
      assigns[:blog].should redirect_to(blogs_path)
      flash[:notice].should =~ /Successfully destroyed blog/
    end
  end

  describe "PUT 'Update'" do
   lambda do
    put :update, :id => @blog
    assigns[:blog].should be_an_instance_of(Blog)
    assigns[:blog].should_not be_new_record
   end
    
    describe "failure" do
        before(:each)do
          @blog = { :title => "", :body => ""}
        end

      it "should not update a blog" do
          lambda do
            get :create, :blog => @blog
            response.should_not change(Blog, :count)
          end
      end

      it "should have a failure message" do
        lambda do
          post :create, :blog => @blog
          flash[:notice].should =~ /Update Failed/
        end
      end

      it "should render template new" do
        lambda do
          post :create, :blog => @blog
          assigns[:blog].should render_template('new')
        end
      end
   end

   describe "success" do
      before(:each) do
        @attr = {:title => "kirti parihar", :body=> "this is my first blog,i m very happy"}
      end

      it "should create a blog" do
        lambda do
          post :create, :blog => @body
        end.should change(Blog, :count).by(0)
      end

      it "should have a success message" do
        lambda do
          post :create, :blog => @blog
          flash[:notice].should =~ /Successfully updated blog/
        end
      end

      it "should redirect to index page" do
        lambda do
          post :create, :blog => @blog
          assigns[:blog].should redirect_to :blogs
        end
      end
   end

 end

# describe "GET 'Preview'" do
#    it "should be successful" do
#      get :preview, id => @blog
#      assigns[:blog].should be_an_instance_of(Blog)
#      assigns[:blog].should be_a_new_record
#      assigns[:blog].should_not be_nil
#    end
# end

end