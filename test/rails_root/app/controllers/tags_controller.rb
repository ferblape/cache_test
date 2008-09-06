class TagsController < ApplicationController

  caches_action :index
    
  def index
    @tags = Tag.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @tags.to_xml }
    end
  end

  def update
    @tag = Tag.find_by_id(params[:id])

    respond_to do |format|
      if @tag && @tag.update_attributes(params[:tag])
        flash[:notice] = 'Tag was successfully updated.'
        expire_action(:action => 'index', :controller => 'tags')
        format.html { redirect_to :action => 'index' }
        format.xml  { head :ok }
      else        
        format.html { redirect_to :action => 'index' }
        format.xml  { render :xml => @post.errors.to_xml }
      end
    end
  end

end
