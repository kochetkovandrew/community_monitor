require 'test_helper'

class DrugGroupsControllerTest < ActionController::TestCase
  setup do
    @drug_group = drug_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:drug_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create drug_group" do
    assert_difference('DrugGroup.count') do
      post :create, drug_group: { name: @drug_group.name, translation: @drug_group.translation }
    end

    assert_redirected_to drug_group_path(assigns(:drug_group))
  end

  test "should show drug_group" do
    get :show, id: @drug_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @drug_group
    assert_response :success
  end

  test "should update drug_group" do
    patch :update, id: @drug_group, drug_group: { name: @drug_group.name, translation: @drug_group.translation }
    assert_redirected_to drug_group_path(assigns(:drug_group))
  end

  test "should destroy drug_group" do
    assert_difference('DrugGroup.count', -1) do
      delete :destroy, id: @drug_group
    end

    assert_redirected_to drug_groups_path
  end
end
