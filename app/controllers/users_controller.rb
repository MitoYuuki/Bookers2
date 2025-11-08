class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]
  before_action :set_user, only: [:show, :edit, :update]    # @user の取得を共通化
  before_action :correct_user, only: [:edit, :update]       # 権限チェック
  
  # 新規登録処理
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "User created successfully."
    else
      render :new  # 失敗時にエラーを表示しつつフォームに戻る
    end
  end

  def index
    @users = User.all
    @book = current_user.books.build if user_signed_in? # サイドバー用フォーム 
    @display_user = current_user
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = current_user.books.build if user_signed_in? # サイドバー用フォーム
  end

  def edit
    #@user = User.find(params[:id])
    #if @user != current_user
    #  redirect_to books_path
    #end
  end

  def update
    #@user = User.find(params[:id])             # ユーザーの取得
    if @user.update(user_params)                  # ユーザーのアップデート
    redirect_to user_path(@user), notice: "You have updated user successfully."# ユーザーの詳細ページへのリダイレクト
    else
      render :edit
    end               
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def correct_user
    unless current_user == @user
      flash[:alert] = "You are not authorized to edit this user."
      redirect_to user_path(current_user)
    #redirect_to books_path, alert: "You are not authorized to access this page." unless current_user == @user
    end
  end
  
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
