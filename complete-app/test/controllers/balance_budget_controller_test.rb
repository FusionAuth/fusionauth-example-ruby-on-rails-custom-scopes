require "test_helper"

class MakeChangeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get balance_budget_index_url
    assert_response :success
  end
end
