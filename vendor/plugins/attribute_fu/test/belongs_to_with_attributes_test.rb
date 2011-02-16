require File.dirname(__FILE__) + '/test_helper'

class CameraTest < ActiveSupport::TestCase
  should_belong_to :user

  context "user_attributes" do
    context "updating existing with valid attributes" do
      setup do
        create_model_and_associated
        @camera.user_attributes = { :name => 'Nigel' }
      end

      context "before save" do
        should "update attributes of associated models in memory" do
          assert_equal "Nigel", @camera.user.name, "name attribute of associated model was not updated."
        end

        should "not, however, have saved new attributes of associated models" do
          assert_equal "Nicolas", @user.reload.name, "name attribute of associated model was saved but should not have been."
        end
      end

      context "after save" do
        setup do
          @camera.save
        end

        should "update attributes of associated models" do
          @user.reload
          assert_equal "Nigel", @user.name, "name attribute of associated model was not updated."
        end
      end

      context "with user_attributes = nil" do
        setup do
          @camera.save
          @camera.user_attributes = nil
          @camera.save
        end

        should "clear association" do
          assert @camera.user.nil?, "@camera.user was not cleared"
        end

        should "delete associated model, if :dependent => :delete" do
          assert_raise(ActiveRecord::RecordNotFound) { @user.reload }
        end
      end
    end # context "updating existing with valid attributes"


    context "creating new with valid attributes" do
      setup do
        create_model
        @user_count = User.count
        @camera.user_attributes = { :name => 'Helmut' }
      end

      context "1. before save" do
        should "update attributes of associated models in memory" do
          assert_equal "Helmut", @camera.user.name, "name attribute of associated model was not updated."
        end

        should "not, however, have saved new attributes of associated models" do
          assert @camera.user.new_record?
          assert_equal @user_count, User.count
        end
      end

      context "2. after save" do
        setup do
          @camera.save!
        end

        should "save associated model, creating new record" do
          assert_equal false, @camera.user.new_record?
          assert_equal @user_count + 1, User.count
        end
      end
    end # context "creating new with valid attributes"


    context "updating existing with invalid attributes" do
      setup do
        create_model_and_associated
        @saved = @camera.update_attributes :user_attributes => { :name => 'invalid' }
      end

      should "update attributes of associated models in memory" do
        assert_equal "invalid", @camera.user.name
      end

      should "not, however, have saved new attributes of associated models" do
        assert_equal "Nicolas", @user.reload.name
      end
      
      should "not save" do
        assert !@saved
      end
      
      should "have errors on child" do
        assert @camera.user.errors.on(:name)
      end
    end


    context "creating new with invalid attributes" do
      setup do
        create_model
        @saved = @camera.update_attributes :user_attributes => { :name => 'invalid' }
      end
      
      should "not save" do
        assert !@saved
      end
      
      should "have errors on child" do
        assert @camera.user.errors.on(:name)
      end
    end

  end # context "user_attributes"
  
private
  def create_model
    @camera = Camera.create!(:make => "Canon", :model => "Powershot G10")
  end

  def create_model_and_associated
    create_model
    @user = @camera.create_user :name => 'Nicolas'
  end

end

