require 'test_helper'

class CopyMessagesControllerTest < ActionController::TestCase
  setup do
    @copy_message = copy_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:copy_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create copy_message" do
    assert_difference('CopyMessage.count') do
      post :create, copy_message: { body: @copy_message.body, raw: @copy_message.raw, user_vk_id: @copy_message.user_vk_id }
    end

    assert_redirected_to copy_message_path(assigns(:copy_message))
  end

  test "should show copy_message" do
    get :show, id: @copy_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @copy_message
    assert_response :success
  end

  test "should update copy_message" do
    patch :update, id: @copy_message, copy_message: { body: @copy_message.body, raw: @copy_message.raw, user_vk_id: @copy_message.user_vk_id }
    assert_redirected_to copy_message_path(assigns(:copy_message))
  end

  test "should destroy copy_message" do
    assert_difference('CopyMessage.count', -1) do
      delete :destroy, id: @copy_message
    end

    assert_redirected_to copy_messages_path
  end
end
