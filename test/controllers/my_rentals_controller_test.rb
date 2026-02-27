require "test_helper"

class MyRentalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get my_rentals_index_url
    assert_response :success
  end
end
