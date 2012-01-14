require 'test_helper'

class MyCollectionCommentsControllerTest < ActionController::TestCase
  setup do
    @my_collection_comment = my_collection_comments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_collection_comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_collection_comment" do
    assert_difference('MyCollectionComment.count') do
      post :create, :my_collection_comment => @my_collection_comment.attributes
    end

    assert_redirected_to my_collection_comment_path(assigns(:my_collection_comment))
  end

  test "should show my_collection_comment" do
    get :show, :id => @my_collection_comment.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @my_collection_comment.to_param
    assert_response :success
  end

  test "should update my_collection_comment" do
    put :update, :id => @my_collection_comment.to_param, :my_collection_comment => @my_collection_comment.attributes
    assert_redirected_to my_collection_comment_path(assigns(:my_collection_comment))
  end

  test "should destroy my_collection_comment" do
    assert_difference('MyCollectionComment.count', -1) do
      delete :destroy, :id => @my_collection_comment.to_param
    end

    assert_redirected_to my_collection_comments_path
  end
end
