#coding:utf-8

class UsersController < ApplicationController
  PER_PAGE = 15


  def new
    @user = User.new
  end

  def show
    @user = UserDecorator.find_by_id!(params[:id])
    collection = @user.asciicasts.
      includes(:user).
      order("created_at DESC").
      page(params[:page]).
      per(PER_PAGE)

    @asciicasts = AsciicastDecorator.decorate(collection)
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      self.current_user = @user
      redirect_back_or_to root_url, :notice => "Signed in!"
    else
      render 'users/new', :status => 422
    end
  end

  def edit
    @user = current_user 
  end

  def update
    current_user.update_attributes(params[:user])
    redirect_to '/',
                :notice => '修改成功.'
  end


end
