require 'test_helper'

class MyCollectionItemsControllerTest < ActionController::TestCase
  setup do
    @my_collection_item = my_collection_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_collection_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_collection_item" do
    assert_difference('MyCollectionItem.count') do
      post :create, :my_collection_item => @my_collection_item.attributes
    end

    assert_redirected_to my_collection_item_path(assigns(:my_collection_item))
  end

  test "should show my_collection_item" do
    get :show, :id => @my_collection_item.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @my_collection_item.to_param
    assert_response :success
  end

  test "should update my_collection_item" do
    put :update, :id => @my_collection_item.to_param, :my_collection_item => @my_collection_item.attributes
    assert_redirected_to my_collection_item_path(assigns(:my_collection_item))
  end

  test "should destroy my_collection_item" do
    assert_difference('MyCollectionItem.count', -1) do
      delete :destroy, :id => @my_collection_item.to_param
    end

    assert_redirected_to my_collection_items_path
  end
end
