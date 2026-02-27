require "test_helper"

class MyListingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get my_listings_index_url
    assert_response :success
  end
end
