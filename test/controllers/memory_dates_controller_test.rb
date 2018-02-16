require 'test_helper'

class MemoryDatesControllerTest < ActionController::TestCase
  setup do
    @memory_date = memory_dates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:memory_dates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create memory_date" do
    assert_difference('MemoryDate.count') do
      post :create, memory_date: { day: @memory_date.day, description: @memory_date.description, kind: @memory_date.kind, month: @memory_date.month, year: @memory_date.year }
    end

    assert_redirected_to memory_date_path(assigns(:memory_date))
  end

  test "should show memory_date" do
    get :show, id: @memory_date
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @memory_date
    assert_response :success
  end

  test "should update memory_date" do
    patch :update, id: @memory_date, memory_date: { day: @memory_date.day, description: @memory_date.description, kind: @memory_date.kind, month: @memory_date.month, year: @memory_date.year }
    assert_redirected_to memory_date_path(assigns(:memory_date))
  end

  test "should destroy memory_date" do
    assert_difference('MemoryDate.count', -1) do
      delete :destroy, id: @memory_date
    end

    assert_redirected_to memory_dates_path
  end
end
