require 'test_helper'

class EmailPreferencesControllerTest < ActionController::TestCase
  setup do
    @email_preference = email_preferences(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:email_preferences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create email_preference" do
    assert_difference('EmailPreference.count') do
      post :create, :email_preference => @email_preference.attributes
    end

    assert_redirected_to email_preference_path(assigns(:email_preference))
  end

  test "should show email_preference" do
    get :show, :id => @email_preference.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @email_preference.to_param
    assert_response :success
  end

  test "should update email_preference" do
    put :update, :id => @email_preference.to_param, :email_preference => @email_preference.attributes
    assert_redirected_to email_preference_path(assigns(:email_preference))
  end

  test "should destroy email_preference" do
    assert_difference('EmailPreference.count', -1) do
      delete :destroy, :id => @email_preference.to_param
    end

    assert_redirected_to email_preferences_path
  end
end
