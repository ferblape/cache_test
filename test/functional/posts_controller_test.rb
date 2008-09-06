require File.dirname(__FILE__) + '/../test_helper'
require 'posts_controller'

class PostsController; def rescue_action(e) raise e end; end

class PostsControllerTest < Test::Unit::TestCase

  fixtures :all

  def setup
    @controller = PostsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_cache_fragment_index
    @request.session[:logged_in] = true

    assert_cache_fragment('total_posts') do
      get :index, :user_id => users(:first)
      assert_response :success
    end
  end
  
  def test_not_cache_other_fragments
    @request.session[:logged_in] = true

    assert_not_cache_fragment('wadus_fragment') do
      get :index, :user_id => users(:first)
      assert_response :success
    end    
  end
  
  def test_cache_multiple_fragment_index
    @request.session[:logged_in] = true

    assert_cache_fragment(
      'total_posts',
      {:fragment => 'posts', :id => posts(:first).id}
    ) do
      get :index, :user_id => users(:first)
      assert_response :success
    end
  end
  
  def test_create_post_expire_fragments
    @request.session[:logged_in] = true

    assert_expire_fragment('total_posts')  do
      assert_difference 'Post.count' do
        post :create, :post => { :title => 'title wadus', :body => 'wadus body', :user_id => users(:first).id }, :user_id => users(:first).id
        assert_response :redirect
      end
    end
  end

end
