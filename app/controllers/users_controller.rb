class UsersController < ApplicationController
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = user.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
  	password = params[:user].delete :password
  	@user = User.new params[:user]
  	@user.password = password
  	respond_to do |format|
      if @user.save
      	sign_in(@user)
        format.html { redirect_to games_path, notice: 'user was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end
end
