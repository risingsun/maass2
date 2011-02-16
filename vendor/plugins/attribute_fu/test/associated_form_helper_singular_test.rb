require File.dirname(__FILE__)+'/test_helper'

class AssociatedFormHelperSingularTest < Test::Unit::TestCase
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include AttributeFu::AssociatedFormHelper
    
  def setup
    @user = User.create!(:name => 'Olaf')
    @controller = mock()
    @controller.stubs(:url_for).returns 'asdf'
    @controller.stubs(:protect_against_forgery?).returns false
    stubs(:protect_against_forgery?).returns false
  end
    
  context "fields for associated" do
    context "with existing object" do
      setup do
        @user.create_camera :make => "Kanon", :model => "Powershot G10"
        @erbout = fields_for_associated(@user.camera)
      end

      should "name field with attribute_fu naming conventions" do
        assert_match '"user[camera_attributes][model]"', @erbout
      end
    end

    context "with non-existent object" do
      setup do
        @erbout = fields_for_associated(@user.build_camera)
      end

      should "name field with attribute_fu naming conventions" do
        assert_match '"user[camera_attributes][model]"', @erbout
      end
    end
    
    context "with overridden name" do
      setup do
        _erbout = ''
        fields_for(:user) do |f|
          f.fields_for_associated_object(@user.build_camera, :name => :something_else) do |camera|
            _erbout.concat camera.text_field(:model)
          end
        end
        
        @erbout = _erbout
      end

      should "use override name" do
        assert_dom_equal "<input name='user[something_else_attributes][model]' size='30' type='text' id='user_something_else_attributes_model' />", @erbout
      end
    end
  end

  context "render_associated_form" do
    setup do
      camera = @user.build_camera
      
      associated_form_builder = mock()
      
      _erbout = ''
      fields_for(:user) do |f|
        f.stubs(:fields_for_associated_object).yields(associated_form_builder)
        expects(:render).with(:partial => "camera", :locals => { :camera => camera, :f => associated_form_builder })
        _erbout.concat f.render_associated_form(camera).to_s
      end
      
      @erbout = _erbout
    end
    
    should "extract the correct parameters for render" do
      # assertions in mock
    end
  end
  
  context "render_associated_form with specified partial name" do
    setup do
      camera = @user.build_camera
      
      associated_form_builder = mock()
      
      _erbout = ''
      fields_for(:user) do |f|
        f.stubs(:fields_for_associated_object).yields(associated_form_builder)
        expects(:render).with(:partial => "somewhere/something.html.erb", :locals => { :something => camera, :f => associated_form_builder })
        _erbout.concat f.render_associated_form(camera, :partial => "somewhere/something.html.erb").to_s
      end
      
      @erbout = _erbout
    end
    
    should "extract the correct parameters for render" do
      # assertions in mock
    end
  end
  
  context "render_associated_form with collection" do
    setup do
      associated_form_builder = mock()
      new_camera = Camera.new
      @user.expects(:build_camera).returns(new_camera)
      
      _erbout = ''
      fields_for(:user) do |f|
        f.stubs(:fields_for_associated_object).yields(associated_form_builder)
        expects(:render).with(:partial => "camera", :locals => { :camera => new_camera, :f => associated_form_builder })
        _erbout.concat f.render_associated_form(@user.camera || @user.build_camera).to_s
      end
      
      @erbout = _erbout
    end
    
    should "extract the correct parameters for render" do
      # assertions in mock
    end
  end
  
  context "render_associated_form with overridden name" do
    setup do
      associated_form_builder = mock()
      camera = @user.build_camera
      
      _erbout = ''
      fields_for(:user) do |f|
        f.stubs(:fields_for_associated_object).with(camera, :name => 'something_else').yields(associated_form_builder)
        expects(:render).with(:partial => "something_else", :locals => { :something_else => camera, :f => associated_form_builder })
        _erbout.concat f.render_associated_form(@user.camera, :name => :something_else).to_s
      end
      
      @erbout = _erbout
    end
    
    should "render with correct parameters" do
      # assertions in mock
    end
  end
  
  private
    def fields_for_associated(object, &block)
      _erbout = ''
      fields_for(:user) do |f|
        _erbout.concat(f.fields_for_associated_object(object) do |f2|
          f2.text_field(:model)
        end)
        
        _erbout.concat yield(f) if block_given?
      end
      
      _erbout
    end
    
    def remove_link(*args)
      @erbout = fields_for_associated(@user.build_camera) do |f|
        f.fields_for_associated_object(@user.build_camera) do |camera|
          camera.remove_link *args
        end
      end
    end
end

