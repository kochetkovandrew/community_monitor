require "application_system_test_case"

class Calendar2020sTest < ApplicationSystemTestCase
  setup do
    @calendar2020 = calendar2020s(:one)
  end

  test "visiting the index" do
    visit calendar2020s_url
    assert_selector "h1", text: "Calendar2020s"
  end

  test "creating a Calendar2020" do
    visit calendar2020s_url
    click_on "New Calendar2020"

    fill_in "Day", with: @calendar2020.day
    fill_in "Description", with: @calendar2020.description
    click_on "Create Calendar2020"

    assert_text "Calendar2020 was successfully created"
    click_on "Back"
  end

  test "updating a Calendar2020" do
    visit calendar2020s_url
    click_on "Edit", match: :first

    fill_in "Day", with: @calendar2020.day
    fill_in "Description", with: @calendar2020.description
    click_on "Update Calendar2020"

    assert_text "Calendar2020 was successfully updated"
    click_on "Back"
  end

  test "destroying a Calendar2020" do
    visit calendar2020s_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Calendar2020 was successfully destroyed"
  end
end
