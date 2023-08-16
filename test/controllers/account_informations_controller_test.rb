require "test_helper"

class AccountInformationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account_information = account_informations(:one)
  end

  test "should get index" do
    get account_informations_url
    assert_response :success
  end

  test "should get new" do
    get new_account_information_url
    assert_response :success
  end

  test "should create account_information" do
    assert_difference("AccountInformation.count") do
      post account_informations_url, params: { account_information: {  } }
    end

    assert_redirected_to account_information_url(AccountInformation.last)
  end

  test "should show account_information" do
    get account_information_url(@account_information)
    assert_response :success
  end

  test "should get edit" do
    get edit_account_information_url(@account_information)
    assert_response :success
  end

  test "should update account_information" do
    patch account_information_url(@account_information), params: { account_information: {  } }
    assert_redirected_to account_information_url(@account_information)
  end

  test "should destroy account_information" do
    assert_difference("AccountInformation.count", -1) do
      delete account_information_url(@account_information)
    end

    assert_redirected_to account_informations_url
  end
end
