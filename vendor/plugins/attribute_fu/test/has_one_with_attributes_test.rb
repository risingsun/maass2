require File.dirname(__FILE__) + '/test_helper'

class UserTest < ActiveSupport::TestCase
  should_have_one :camera

  context "camera_attributes" do
    context "updating existing with valid attributes" do
      setup do
        create_model_and_associated
        @user.camera_attributes = { :make => 'Canon' }
      end

      context "before save" do
        should "update attributes of associated models in memory" do
          assert_equal "Canon", @user.camera.make, "make attribute of associated model was not updated."
        end

        should "not, however, have saved new attributes of associated models" do
          assert_equal "Kanon", @camera.reload.make, "make attribute of associated model was saved but should not have been."
        end
      end

      context "after save" do
        setup do
          @user.save
        end

        should "update attributes of associated models" do
          @camera.reload
          assert_equal "Canon", @camera.make, "make attribute of associated model was not updated."
        end
      end

      context "with camera_attributes = nil" do
        setup do
          @user.save
          @user.camera_attributes = nil
          @user.save
        end

        should "clear association" do
          assert @user.camera.nil?, "@user.camera was not cleared"
        end

        should "destroy associated model, if :dependent => :destroy" do
          assert_raise(ActiveRecord::RecordNotFound) { @camera.reload }
        end
      end
    end # context "updating existing with valid attributes"


    context "creating new with valid attributes" do
      setup do
        @camera_count = Camera.count
        create_model
        @user.camera_attributes = { :make => 'Nikon', :model => 'P6000' }
      end

      context "1. before save" do
        should "update attributes of associated models in memory" do
          assert_equal "Nikon", @user.camera.make, "make attribute of associated model was not updated."
        end

        should "not, however, have saved new attributes of associated models" do
          assert @user.camera.new_record?
          assert_equal @camera_count, Camera.count
        end
      end

      context "2. after save" do
        setup do
          @user.save!
        end

        should "save associated model, creating new record" do
          assert_equal false, @user.camera.new_record?
          assert_equal @camera_count + 1, Camera.count
        end
      end
    end # context "creating new with valid attributes"


    context "updating existing with invalid attributes" do
      setup do
        create_model_and_associated
        @saved = @user.update_attributes :camera_attributes => { :make => 'Make', :model => nil }
      end

      should "update attributes of associated models in memory" do
        assert_equal "Make", @user.camera.make
        assert_equal nil,    @user.camera.model
      end

      should "not, however, have saved new attributes of associated models" do
        assert_equal "Kanon",         @camera.reload.make
        assert_equal "Powershot G10", @user.camera.model
      end
      
      should "not save" do
        assert !@saved
      end
      
      should "have errors on child" do
        assert @user.camera.errors.on(:model)
      end
    end


    context "creating new with invalid attributes" do
      setup do
        create_model
        @saved = @user.update_attributes :camera_attributes => { :make => 'Make' }
      end
      
      should "not save" do
        assert !@saved
      end
      
      should "have errors on child" do
        assert @user.camera.errors.on(:model)
      end
    end

  end # context "camera_attributes"
  
private

  def create_model
    @user = User.create!(:name => 'Nicolas')
  end

  def create_model_and_associated
    create_model
    @camera = @user.create_camera :make => "Kanon", :model => "Powershot G10"
  end

end
