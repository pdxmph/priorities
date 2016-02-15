class CommentsController < ApplicationController


def update
  @comment = Comment.find(params[:id])
  @page = @comment.page
  if @comment.update(:content => params[:comment][:content])
    respond_to do |format|
      format.js {render :action => 'update.js.haml', :object => @page}
    end
    else
      respond_to do |format|
        format.html {redirect_to :back, :alert => "Didn't save your change."}
        format.js {redirect_to :back, :alert => "Something went wrong."}
      end
   end
end

  
  def create
    @comment = Comment.new(:content => params[:comment][:content], :user_id => params[:comment][:user_id], :page_id => params[:comment][:page_id])
    if @comment.save
      @page = @comment.page
      respond_to do |format|
        format.js {render :action => 'update.js.haml',:object => @page}
      end
    else
      respond_to do |format|
        format.html {redirect_to :back, :alert => "Comment failed to save."}
      end
    end
  end

  def destroy
    @comment = Comment.find params[:id]
    if @comment.destroy
      respond_to do |format|
       format.js {render :action => 'update.js.haml', :object => @page}
       format.html {redirect_to :back, :notice => "Comment deleted."}
      end
    end
  end
  
end
