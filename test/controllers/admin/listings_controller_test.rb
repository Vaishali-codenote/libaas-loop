require "test_helper"

class Admin::ListingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_listings_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_listings_show_url
    assert_response :success
  end
end
