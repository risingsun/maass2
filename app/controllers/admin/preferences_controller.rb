class Admin::PreferencesController < ApplicationController

  layout "admin"
 
  def index
    
  end

  def new_title
    @title = Title.new
    respond_to do |format|
      format.js do
        render 'admin/preferences/new_title', :title => @title 
      end
    end
  end

  def add_title
    @title = Title.new(params[:title])
    unless params[:title][:name].blank?
      unless @title.save
        flash[:error] = " Not created successfully"
      end
    end
    redirect_to admin_preferences_path
  end

  def edit_title    
    @titles = Title.all
    respond_to do |format|
      format.js do
        render 'admin/preferences/edit_title', :title => @titles
      end
    end
  end

  def update_title    
    params[:titles].values.each do |title|
      @title = Title.where("id =?", title[:id]).first
      @title.update_attributes(title)
    end
    redirect_to admin_preferences_path
  end

  def delete_title
    @title =Title.find(params[:id])
    @title.destroy if @title
    respond_to do |format|
      format.js do
        render :partial => 'admin/preferences/title'
      end
    end    
  end

  def new_house_name
    @house_name = HouseName.new
    respond_to do |format|
      format.js do
        render 'admin/preferences/new_house_name', :title => @house_name
      end    
    end
  end

  def add_house_name
    @house_name = HouseName.new(params[:house_name])
    unless params[:house_name][:name].blank?
      unless @house_name.save
        flash[:error] = " Not created successfully"
      end
    end
    redirect_to admin_preferences_path
  end

  def edit_house_name
    @house_names = HouseName.all
    respond_to do |format|
      format.js do
        render 'admin/preferences/edit_house_name', :title => @house_names 
      end
    end
  end

  def update_house_name
    params[:house_names].values.each do |house_name|
      @house_name = HouseName.where("id =?", house_name[:id]).first
      @house_name.update_attributes(house_name)
    end
    redirect_to admin_preferences_path
  end

  def delete_house_name
    @housename =HouseName.find(params[:id])
    @housename.destroy if @housename
    respond_to do |format|
      format.js do
        render 'admin/preferences/house_name'
      end
    end
  end

  private
  
  def allow_to
    super :admin, :all => true
  end

end