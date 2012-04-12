require 'test_helper'

class PhotoContestsControllerTest < ActionController::TestCase
  setup do
    @photo_contest = photo_contests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:photo_contests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create photo_contest" do
    assert_difference('PhotoContest.count') do
      post :create, :photo_contest => @photo_contest.attributes
    end

    assert_redirected_to photo_contest_path(assigns(:photo_contest))
  end

  test "should show photo_contest" do
    get :show, :id => @photo_contest.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @photo_contest.to_param
    assert_response :success
  end

  test "should update photo_contest" do
    put :update, :id => @photo_contest.to_param, :photo_contest => @photo_contest.attributes
    assert_redirected_to photo_contest_path(assigns(:photo_contest))
  end

  test "should destroy photo_contest" do
    assert_difference('PhotoContest.count', -1) do
      delete :destroy, :id => @photo_contest.to_param
    end

    assert_redirected_to photo_contests_path
  end
end
