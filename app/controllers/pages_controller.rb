class PagesController < ApplicationController
  respond_to :html, :json, :xml, :js
  autocomplete :tag, :name, :full => true, :class_name => 'ActsAsTaggableOn::Tag'

  def find_page
    @url = params[:url]

    if @url.match(/\/latest\//)
      proj_path = URI.parse(@url).path.split("/")[1]
      project = Project.find_by_name(proj_path)
      version = project.versions.published.order(version_number: :desc).first.version_number
      @url.sub!(/\/latest\//,"/#{version}/")
    end

    if @url.match(/^https/)
      @url.sub!(/^https/, "http")
    end

    if @url.match(/#.*$/)
      @url.sub!(/#.*$/, "")
    end
    
    if @page = Page.find_by_live_url(@url)
      redirect_to @page
    else
      render :template => 'application/page_not_found', :locals => {:url => @url}
    end
  end
  
  def missing_pages
    @pages = Page.missing_files
    render :template => "pages/missing_pages", :locals => {:pages => @pages}   
  end

  def destroy
    @page = Page.find(params[:id])

    if @page.destroy
      respond_to do |format|
        format.html { redirect_to  project_version_path(:id => @page.version_id, :project_id => @page.version.project_id), alert: "Deleted the page #{@page.filename} from the database. Do you need to 301 Redirect it, too?"}
      end
    else
      redirect_to @page
    end
  end
    
  def tags
    @tags = Page.tag_counts
  end
  
  def tag
    @tag = params[:tag_name]
    @title = "Pages tagged with #{@tag}"
    @pages = Page.tagged_with(@tag)
  end
  
  def pages
    @version = params[:version]
    @project = params[:project]
    @pages = Page.where("version = ? AND project = ?", @version, @project)
    @title = "#{@project.display_name} #{@version.version_number}"
  end

  def show
    @page = Page.friendly.find(params[:id])
    @user = current_user
    @title = @page.title
    @matching_pages = @page.matching_files
    @recent_git = @page.recent_git
    render :template => "pages/show"
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Couldn't find this page. It may have been deleted by another user."
      if request.env["HTTP_REFERER"]
        redirect_to :back
      else
        redirect_to :projects
      end
    rescue Git::GitExecuteError
      flash[:alert] = "Git bombed"
  end


  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params.require(:page).permit(:tag_list))
      flash[:notice] = "Successfully updated page."
      redirect_to @page
    else
      flash[:alert] = "Didn't update the page"
      redirect_to @page
    end
  end

  def add_to_tag_list
    @page = Page.find(params[:page][:page_id])
    @tags = params[:page][:tag_list]
    @page.tag_list.add(@tags, parse: true)

    if @page.save
      respond_to do |format|
       format.html { redirect_to :back }
       format.js  { render :action => 'update_tags.js.haml'}
      end
    else
      flash[:alert] = "Failed to change tags"
    end
  end
  
  def remove_tag
    @page = Page.find(params[:page_id])
    @tag = params[:tag]
    
    if @page.tag_list.remove(@tag)
      @page.save
      respond_to do |format|
        #format.html { redirect_to :back }
        format.js  { render :action => 'update_tags.js.haml'}
      end
    else
      flash[:notice] = "Didn't update the tags"
      redirect_to @page
    end
  end

  
  def toggle_page_vote
    @page = Page.find(params[:page_id])
    @user = current_user

    if current_user.voted_up_on? @page
      @page.downvote_from @user
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    else
      @page.vote_by :voter => @user
      respond_to do |format|
       format.js 
       format.html { redirect_to :back }
      end
    end
  end

  def toggle_reviewed
    @page = Page.find(params[:page_id])

    if @page.reviewed
      @page.reviewed = false
    else
      @page.reviewed = true
    end

    if @page.save
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  
  def set_page_owner
    @page = Page.find(params[:page_id])
    @user = User.find(params[:user_id])

    if params[:action_id] == "disown"
      @page.user_id = nil
    else
      @page.user_id = @user.id
    end
    
    if @page.save
      respond_to do |format|
       format.js { render :action => 'set_page_owner.js.haml', :locals => {:user => @user.id}}
       format.html
      end
    end  
  end
  
  def set_page_risk
    @risk = params[:risk]
    @page = Page.find(params[:page_id])
    @page.risk = @risk

    if @page.save
      respond_to do |format|
        format.js { render :action => 'update_risk_button.js.haml', :locals => {:id => params[:page_id], :risk => @page.risk}}
        format.html
      end
    end
  end

  def set_page_priority
    @priority = params[:priority]
    @page = Page.find(params[:page_id])
    @page.priority = @priority

    if @page.save
      respond_to do |format|
        format.js { render :action => 'update_priority_button.js.haml', :locals => {:id => params[:page_id], :priority => @page.priority}}
        format.html 
      end
    end
    
  end
  
  def delete_comment
    @comment = Comment.find params[:id]
    @page = Page.find params[:page]
    if @comment.destroy
      respond_to do |format|
        format.html {redirect_to :back, :notice => "Comment deleted."}
        format.js
      end
    end
  end

  def content_reimport
    @page = Page.find params[:id]
    if @page.content_reimport && @page.element_import
      respond_to do |format|
        format.js {render :object => @page}
      end
    end
  end
end
