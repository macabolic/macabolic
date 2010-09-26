require 'test_helper'

class MyCollectionDetailsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_collection_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_collection_detail" do
    assert_difference('MyCollectionDetail.count') do
      post :create, :my_collection_detail => { }
    end

    assert_redirected_to my_collection_detail_path(assigns(:my_collection_detail))
  end

  test "should show my_collection_detail" do
    get :show, :id => my_collection_details(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => my_collection_details(:one).to_param
    assert_response :success
  end

  test "should update my_collection_detail" do
    put :update, :id => my_collection_details(:one).to_param, :my_collection_detail => { }
    assert_redirected_to my_collection_detail_path(assigns(:my_collection_detail))
  end

  test "should destroy my_collection_detail" do
    assert_difference('MyCollectionDetail.count', -1) do
      delete :destroy, :id => my_collection_details(:one).to_param
    end

    assert_redirected_to my_collection_details_path
  end
end
