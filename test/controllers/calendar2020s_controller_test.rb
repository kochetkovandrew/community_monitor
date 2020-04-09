require 'test_helper'

class Calendar2020sControllerTest < ActionDispatch::IntegrationTest
  setup do
    @calendar2020 = calendar2020s(:one)
  end

  test "should get index" do
    get calendar2020s_url
    assert_response :success
  end

  test "should get new" do
    get new_calendar2020_url
    assert_response :success
  end

  test "should create calendar2020" do
    assert_difference('Calendar2020.count') do
      post calendar2020s_url, params: { calendar2020: { day: @calendar2020.day, description: @calendar2020.description } }
    end

    assert_redirected_to calendar2020_url(Calendar2020.last)
  end

  test "should show calendar2020" do
    get calendar2020_url(@calendar2020)
    assert_response :success
  end

  test "should get edit" do
    get edit_calendar2020_url(@calendar2020)
    assert_response :success
  end

  test "should update calendar2020" do
    patch calendar2020_url(@calendar2020), params: { calendar2020: { day: @calendar2020.day, description: @calendar2020.description } }
    assert_redirected_to calendar2020_url(@calendar2020)
  end

  test "should destroy calendar2020" do
    assert_difference('Calendar2020.count', -1) do
      delete calendar2020_url(@calendar2020)
    end

    assert_redirected_to calendar2020s_url
  end
end
