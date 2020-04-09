require "application_system_test_case"

class ShortlinksTest < ApplicationSystemTestCase
  setup do
    @shortlink = shortlinks(:one)
  end

  test "visiting the index" do
    visit shortlinks_url
    assert_selector "h1", text: "Shortlinks"
  end

  test "creating a Shortlink" do
    visit shortlinks_url
    click_on "New Shortlink"

    fill_in "Link", with: @shortlink.link
    fill_in "Short link", with: @shortlink.short_link
    click_on "Create Shortlink"

    assert_text "Shortlink was successfully created"
    click_on "Back"
  end

  test "updating a Shortlink" do
    visit shortlinks_url
    click_on "Edit", match: :first

    fill_in "Link", with: @shortlink.link
    fill_in "Short link", with: @shortlink.short_link
    click_on "Update Shortlink"

    assert_text "Shortlink was successfully updated"
    click_on "Back"
  end

  test "destroying a Shortlink" do
    visit shortlinks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Shortlink was successfully destroyed"
  end
end
