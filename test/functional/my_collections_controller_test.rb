require 'test_helper'

class MyCollectionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_collections)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_collection" do
    assert_difference('MyCollection.count') do
      post :create, :my_collection => { }
    end

    assert_redirected_to my_collection_path(assigns(:my_collection))
  end

  test "should show my_collection" do
    get :show, :id => my_collections(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => my_collections(:one).to_param
    assert_response :success
  end

  test "should update my_collection" do
    put :update, :id => my_collections(:one).to_param, :my_collection => { }
    assert_redirected_to my_collection_path(assigns(:my_collection))
  end

  test "should destroy my_collection" do
    assert_difference('MyCollection.count', -1) do
      delete :destroy, :id => my_collections(:one).to_param
    end

    assert_redirected_to my_collections_path
  end
end
