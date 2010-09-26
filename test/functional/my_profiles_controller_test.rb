require 'test_helper'

class MyProfilesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_profiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_profile" do
    assert_difference('MyProfile.count') do
      post :create, :my_profile => { }
    end

    assert_redirected_to my_profile_path(assigns(:my_profile))
  end

  test "should show my_profile" do
    get :show, :id => my_profiles(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => my_profiles(:one).to_param
    assert_response :success
  end

  test "should update my_profile" do
    put :update, :id => my_profiles(:one).to_param, :my_profile => { }
    assert_redirected_to my_profile_path(assigns(:my_profile))
  end

  test "should destroy my_profile" do
    assert_difference('MyProfile.count', -1) do
      delete :destroy, :id => my_profiles(:one).to_param
    end

    assert_redirected_to my_profiles_path
  end
end
