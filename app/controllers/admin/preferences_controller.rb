class Admin::PreferencesController < ApplicationController

  layout "admin"
 
  def index
    
  end

  def new_title
    @title = Title.new
    respond_to do |format|
      format.js do
        render :partial => 'new_title', :locals=> { :title => @title }
      end
    end
  end

  def add_title
    @title = Title.new(params[:title])
    unless params[:title][:name].blank?
      unless @title.save
        flash[:notice] = " Not created successfully"
      end
    end
    redirect_to admin_preferences_path
  end

  def edit_title    
    @titles = Title.all
    respond_to do |format|
      format.js do
        render :partial => 'edit_title', :locals=> { :title => @titles }
      end
    end
  end

  def update_title    
    params[:titles].values.each do |title|
      @title = Title.find(:first, :conditions => ['id =?',title[:id]])      
      @title.update_attributes(title)
    end
    redirect_to admin_preferences_path
  end

  def delete_title
    @title =Title.find(params[:id])
    @title.destroy if @title
    redirect_to admin_preferences_path
  end

  def new_house_name
    @house_name = HouseName.new
    respond_to do |format|
      format.js do
        render :partial => 'new_house_name', :locals=> { :title => @house_name }
      end    
    end
  end

  def add_house_name
    @house_name = HouseName.new(params[:house_name])
    unless params[:house_name][:name].blank?
      unless @house_name.save
        flash[:notice] = " Not created successfully"
      end
    end
    redirect_to admin_preferences_path
  end

  def edit_house_name
    @house_names = HouseName.all
    respond_to do |format|
      format.js do
        render :partial => 'edit_house_name', :locals=> { :title => @house_names }
      end
    end
  end

  def update_house_name
    params[:house_names].values.each do |house_name|
      @house_name = HouseName.find(:first, :conditions => ['id =?',house_name[:id]])
      @house_name.update_attributes(house_name)
    end
    redirect_to admin_preferences_path
  end

  def delete_house_name
    @housename =HouseName.find(params[:id])
    @housename.destroy if @housename
    redirect_to admin_preferences_path
  end

end