require 'test_helper'

class ArtDrugsControllerTest < ActionController::TestCase
  setup do
    @art_drug = art_drugs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:art_drugs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create art_drug" do
    assert_difference('ArtDrug.count') do
      post :create, art_drug: { name: @art_drug.name }
    end

    assert_redirected_to art_drug_path(assigns(:art_drug))
  end

  test "should show art_drug" do
    get :show, id: @art_drug
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @art_drug
    assert_response :success
  end

  test "should update art_drug" do
    patch :update, id: @art_drug, art_drug: { name: @art_drug.name }
    assert_redirected_to art_drug_path(assigns(:art_drug))
  end

  test "should destroy art_drug" do
    assert_difference('ArtDrug.count', -1) do
      delete :destroy, id: @art_drug
    end

    assert_redirected_to art_drugs_path
  end
end
