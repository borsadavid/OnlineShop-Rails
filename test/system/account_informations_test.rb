require "application_system_test_case"

class AccountInformationsTest < ApplicationSystemTestCase
  setup do
    @account_information = account_informations(:one)
  end

  test "visiting the index" do
    visit account_informations_url
    assert_selector "h1", text: "Account information"
  end

  test "should create account information" do
    visit account_informations_url
    click_on "New account information"

    click_on "Create Account information"

    assert_text "Account information was successfully created"
    click_on "Back"
  end

  test "should update Account information" do
    visit account_information_url(@account_information)
    click_on "Edit this account information", match: :first

    click_on "Update Account information"

    assert_text "Account information was successfully updated"
    click_on "Back"
  end

  test "should destroy Account information" do
    visit account_information_url(@account_information)
    click_on "Destroy this account information", match: :first

    assert_text "Account information was successfully destroyed"
  end
end
