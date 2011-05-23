class Admin::PreferencesController < ApplicationController

  layout "admin"

  authorize_resource :class=> false

  def index    
  end

  def new_title
    @title = Title.new
    respond_to do |format|
      format.js do
        render :partial=> 'admin/preferences/new_title', :locals=>{:title => @title}
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
        render :partial=> 'admin/preferences/edit_title', :locals=>{:title => @titles}
      end
    end
  end

  def update_title    
    params[:title][:titles].values.each do |title|
      @title = Title.find(title[:id])
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
        render :partial => 'admin/preferences/new_house_name', :locals=>{:house_name => @house_name}
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
        render :partial => 'admin/preferences/edit_house_name', :locals=>{:house_name => @house_names}
      end
    end
  end

  def update_house_name
    params[:house_name][:house_names].values.each do |house_name|
      @house_name = HouseName.find(house_name[:id])
      @house_name.update_attributes(house_name)
    end
    redirect_to admin_preferences_path
  end

  def delete_house_name
    @housename =HouseName.find(params[:id])
    @housename.destroy if @housename
    respond_to do |format|
      format.js do
        render :partial=> 'admin/preferences/house_name'
      end
    end
  end
  
end