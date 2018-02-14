require 'test_helper'

class OtherDrugsControllerTest < ActionController::TestCase
  setup do
    @other_drug = other_drugs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:other_drugs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create other_drug" do
    assert_difference('OtherDrug.count') do
      post :create, other_drug: { name: @other_drug.name }
    end

    assert_redirected_to other_drug_path(assigns(:other_drug))
  end

  test "should show other_drug" do
    get :show, id: @other_drug
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @other_drug
    assert_response :success
  end

  test "should update other_drug" do
    patch :update, id: @other_drug, other_drug: { name: @other_drug.name }
    assert_redirected_to other_drug_path(assigns(:other_drug))
  end

  test "should destroy other_drug" do
    assert_difference('OtherDrug.count', -1) do
      delete :destroy, id: @other_drug
    end

    assert_redirected_to other_drugs_path
  end
end
