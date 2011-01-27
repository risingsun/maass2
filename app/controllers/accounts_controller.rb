class AccountsController < ApplicationController

  def new

  end
  def edit
     @account =  current_user.account || current_user.build_account
     @account.save
     @user=current_user
     @permission =@account.permission || @account.build_permission
     @permission.save
     @notification =@account.notification || @account.build_notification
  end

  def create

  end

  def update
     @account = Account.find(params[:id])
     @account.attributes = params[:account]

    if @account.save
      flash[:notice] = "Account created."
      redirect_to edit_account_path(current_user)
    else
      flash[:notice] = "Account is not created."
      render 'edit'
    end

  end

  def show

  end

  def update_default_permission

    @account = Account.find(current_user.account)
    @account.attributes = params[:account]

    if @account.save
      flash[:notice] = "Account created.........."
      User::PERMISSION_FIELDS.each do |x|
        @account.permission.update_attributes({x => @account.default_permission})
      end
     else
         flash[:notice] = "Account was notcreated.........."
     end
    redirect_to edit_account_path(current_user)
  end


end
