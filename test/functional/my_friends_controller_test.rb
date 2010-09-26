require 'test_helper'

class MyFriendsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_friends)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_friend" do
    assert_difference('MyFriend.count') do
      post :create, :my_friend => { }
    end

    assert_redirected_to my_friend_path(assigns(:my_friend))
  end

  test "should show my_friend" do
    get :show, :id => my_friends(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => my_friends(:one).to_param
    assert_response :success
  end

  test "should update my_friend" do
    put :update, :id => my_friends(:one).to_param, :my_friend => { }
    assert_redirected_to my_friend_path(assigns(:my_friend))
  end

  test "should destroy my_friend" do
    assert_difference('MyFriend.count', -1) do
      delete :destroy, :id => my_friends(:one).to_param
    end

    assert_redirected_to my_friends_path
  end
end
