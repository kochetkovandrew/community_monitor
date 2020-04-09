require "application_system_test_case"

class PortalAttachmentsTest < ApplicationSystemTestCase
  setup do
    @portal_attachment = portal_attachments(:one)
  end

  test "visiting the index" do
    visit portal_attachments_url
    assert_selector "h1", text: "Portal Attachments"
  end

  test "creating a Portal attachment" do
    visit portal_attachments_url
    click_on "New Portal Attachment"

    fill_in "Filename", with: @portal_attachment.filename
    fill_in "Guid", with: @portal_attachment.guid
    click_on "Create Portal attachment"

    assert_text "Portal attachment was successfully created"
    click_on "Back"
  end

  test "updating a Portal attachment" do
    visit portal_attachments_url
    click_on "Edit", match: :first

    fill_in "Filename", with: @portal_attachment.filename
    fill_in "Guid", with: @portal_attachment.guid
    click_on "Update Portal attachment"

    assert_text "Portal attachment was successfully updated"
    click_on "Back"
  end

  test "destroying a Portal attachment" do
    visit portal_attachments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Portal attachment was successfully destroyed"
  end
end
