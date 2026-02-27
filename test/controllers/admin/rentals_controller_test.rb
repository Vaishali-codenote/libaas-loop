require "test_helper"

class Admin::RentalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_rentals_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_rentals_show_url
    assert_response :success
  end
end
