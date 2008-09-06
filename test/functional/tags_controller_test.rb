require File.dirname(__FILE__) + '/../test_helper'
require 'tags_controller'

class TagsController; def rescue_action(e) raise e end; end

class TagsControllerTest < Test::Unit::TestCase

  fixtures :all

  def setup
    @controller = TagsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_load_index_should_cache_action
    assert_cache_action do
      get :index
      assert_response :success
    end
  end
  
  def test_load_index_should_not_cache_different_action
    assert_not_cache_action(:controller => 'posts', :action => 'index') do
      get :index
      assert_response :success
    end
  end
  
  def test_update_tag_should_expire_action
    assert_expire_action({:action => 'index', :controller => 'tags'}) do
      post :update, :id => tags(:first).id, :tag => { :name => 'Wadus' }
    end
  end

  def test_update_tag_failed_should_not_expire_action
    assert_not_expire_action({:action => 'index', :controller => 'tags'}) do
      post :update, :id => nil, :tag => { :name => 'Wadus' }
    end
  end
  
end
