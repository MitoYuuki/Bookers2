class UsersController < ApplicationController
  def index
    # 本を登録したことのあるユーザー
    @users = User.joins(:books).distinct
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])             # ユーザーの取得
    if @user.update(user_params)                  # ユーザーのアップデート
    redirect_to user_path(@user), notice: "User updated successfully."# ユーザーの詳細ページへのリダイレクト
    else
      render :edit
    end               
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
