class CommentsController < ApplicationController
  before_action :set_comment, only: [:index, :show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
    respond_with(@comments)
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @owner = User.find(current_user.id)
    @comment = Comment.new(comment_params)
    @category = @comment.category.name

    respond_to do |format|
      if @comment.save
        @comment.create_activity :create, owner: @owner, key: "har kommenterat på en modul: #{view_context.link_to(@category, category_path(@category))}".html_safe
        format.html { redirect_to category_path(@category), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end



  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        #format.json { render :show, status: :ok, location: @comment }
        format.json { respond_with_bip(@comment) }
      else
        format.html { render :edit }
        #format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.json { respond_with_bip(@comment) }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    cat = Category.find(@comment.category_id)
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to category_path(cat.name), notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:msg, :category_id, :user_id, :parent_id)
    end
end
