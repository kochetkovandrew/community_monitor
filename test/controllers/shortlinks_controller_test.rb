require 'test_helper'

class ShortlinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shortlink = shortlinks(:one)
  end

  test "should get index" do
    get shortlinks_url
    assert_response :success
  end

  test "should get new" do
    get new_shortlink_url
    assert_response :success
  end

  test "should create shortlink" do
    assert_difference('Shortlink.count') do
      post shortlinks_url, params: { shortlink: { link: @shortlink.link, short_link: @shortlink.short_link } }
    end

    assert_redirected_to shortlink_url(Shortlink.last)
  end

  test "should show shortlink" do
    get shortlink_url(@shortlink)
    assert_response :success
  end

  test "should get edit" do
    get edit_shortlink_url(@shortlink)
    assert_response :success
  end

  test "should update shortlink" do
    patch shortlink_url(@shortlink), params: { shortlink: { link: @shortlink.link, short_link: @shortlink.short_link } }
    assert_redirected_to shortlink_url(@shortlink)
  end

  test "should destroy shortlink" do
    assert_difference('Shortlink.count', -1) do
      delete shortlink_url(@shortlink)
    end

    assert_redirected_to shortlinks_url
  end
end
