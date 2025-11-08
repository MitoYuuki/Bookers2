class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]
  #before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy] # ログイン必須
  before_action :set_book, only: [:show, :edit, :update, :destroy]                  # @bookの共通化
  before_action :correct_user, only: [:edit, :update, :destroy]                     # 権限チェック

  def new
    @book = Book.new
  end
  
  # 投稿データの保存
  def create
    #@book = Book.new(book_params)
    #@book.user_id = current_user.id
    @book = current_user.books.build(book_params) # current_userに紐付け
    #@book = current_user.books.new(book_params)
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book)
      #redirect_to @book
    else
      @books = Book.all
      render :index
    end
  end

  def index  
    @books = Book.all
    #@book = Book.new
    @book = current_user.books.build if user_signed_in?
  end

  def show
  #@book = Book.find(params[:id])
  @user = @book.user
  end

  def edit 
    #@book = Book.find(params[:id]) 
    #if @user != current_user
    #  redirect_to books_path
    #end
  end

  def destroy
    #book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def update
  #@book = Book.find(params[:id])

  if @book.update(book_params)
    flash[:notice] = "You have updated book successfully."
    redirect_to book_path(@book)
  else
    render :edit
  end
end
  
  # 投稿データのストロングパラメータ
  private

  def set_book
    @book = Book.find(params[:id])
  end

  def correct_user
    unless current_user == @book.user
      flash[:alert] = "You are not authorized to edit this book."
      redirect_to books_path
    end
  end

  def book_params
    params.require(:book).permit(:title, :body)
  end
  
end
