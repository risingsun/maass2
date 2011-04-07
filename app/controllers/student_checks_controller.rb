class StudentChecksController < ApplicationController

  layout "admin"

  before_filter :load_student_checks, :only => [:edit, :update, :destroy, :send_invite]

  def index
    if params[:year] || params[:all]
      @student_checks = StudentCheck.get_students(params)
    end
  end

  def new
    @student_check=StudentCheck.new
  end

  def create
    @student_check = StudentCheck.new(params[:student_check])
    if @student_check.save
      flash[:notice] = 'StudentCheck was successfully created.'
      redirect_to(next_dest)
    else
      render :new
    end
  end
 
  def edit
  end

  def update
    if @student_check.update_attributes(params[:student_check])
      flash[:notice] = 'StudentCheck was successfully updated.'
      redirect_to(next_dest)
    else
      render :edit
    end
  end

  def destroy
    @student_check.destroy
    redirect_to student_checks_path
  end

  def send_bulk_invite
    @students = StudentCheck.with_emails
    @students.each {|s| ArNotifier.delay.invite(s) unless s.emails.empty?}
    flash[:notice] = 'Bulk Invites sent.'
    redirect_to student_checks_path
  end

  def send_invite
    ArNotifier.delay.invite(@student) unless @student.emails.empty?
    flash[:notice] = 'Invite sent.'
    redirect_to student_checks_path
  end

 def view_year_students
   @years = Profile.change_group(params[:group])
   respond_to do |format|
     format.js do
       render :json => @years.to_json
     end
   end
 end

  private    

  def next_dest
    case params[:commit]
    when "Update and Return"
      student_checks_path
    when "Update and Add Another"
      new_student_check_path
    when "Update and Edit"
      edit_student_check_path(@student_check)
    else
      student_checks_path
    end
  end

  def load_student_checks
    @student_check = StudentCheck.find(params[:id])
  end
end
