require 'test_helper'

class PhotoEntriesControllerTest < ActionController::TestCase
  setup do
    @photo_entry = photo_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:photo_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create photo_entry" do
    assert_difference('PhotoEntry.count') do
      post :create, :photo_entry => @photo_entry.attributes
    end

    assert_redirected_to photo_entry_path(assigns(:photo_entry))
  end

  test "should show photo_entry" do
    get :show, :id => @photo_entry.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @photo_entry.to_param
    assert_response :success
  end

  test "should update photo_entry" do
    put :update, :id => @photo_entry.to_param, :photo_entry => @photo_entry.attributes
    assert_redirected_to photo_entry_path(assigns(:photo_entry))
  end

  test "should destroy photo_entry" do
    assert_difference('PhotoEntry.count', -1) do
      delete :destroy, :id => @photo_entry.to_param
    end

    assert_redirected_to photo_entries_path
  end
end
