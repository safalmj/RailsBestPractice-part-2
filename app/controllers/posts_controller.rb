class PostsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  respond_to :html, :xml
  def index
    @posts = Post.all
    # show all posts that have more than 10 comments
    @popular_posts = Post.find_each(:batch_size => 100).collect{|p| p if p.comments.length > 10}.compact
    respond_with(@posts)
  end

  def new
    @post = Post.new
    respond_with(@post)
  end

  def create
    @post = Post.new(params[:post])

    if @post.title.present? && @post.text.present? && @post.save
      flash[:notice] = "Post has been created."
      redirect_to user_post_path(current_user,@post)
    else
      flash[:notice] = "Post has not been created."
      render :action => "new"
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new 
    @comments = Comment.where(post_id:@post.id)
    respond_with(@post, @comment)
  end

end

