require 'test_helper'

class PortalAttachmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @portal_attachment = portal_attachments(:one)
  end

  test "should get index" do
    get portal_attachments_url
    assert_response :success
  end

  test "should get new" do
    get new_portal_attachment_url
    assert_response :success
  end

  test "should create portal_attachment" do
    assert_difference('PortalAttachment.count') do
      post portal_attachments_url, params: { portal_attachment: { filename: @portal_attachment.filename, guid: @portal_attachment.guid } }
    end

    assert_redirected_to portal_attachment_url(PortalAttachment.last)
  end

  test "should show portal_attachment" do
    get portal_attachment_url(@portal_attachment)
    assert_response :success
  end

  test "should get edit" do
    get edit_portal_attachment_url(@portal_attachment)
    assert_response :success
  end

  test "should update portal_attachment" do
    patch portal_attachment_url(@portal_attachment), params: { portal_attachment: { filename: @portal_attachment.filename, guid: @portal_attachment.guid } }
    assert_redirected_to portal_attachment_url(@portal_attachment)
  end

  test "should destroy portal_attachment" do
    assert_difference('PortalAttachment.count', -1) do
      delete portal_attachment_url(@portal_attachment)
    end

    assert_redirected_to portal_attachments_url
  end
end
