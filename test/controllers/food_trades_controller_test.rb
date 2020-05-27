require 'test_helper'

class FoodTradesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get food_trades_index_url
    assert_response :success
  end

  test "should get show" do
    get food_trades_show_url
    assert_response :success
  end

  test "should get new" do
    get food_trades_new_url
    assert_response :success
  end

  test "should get create" do
    get food_trades_create_url
    assert_response :success
  end

  test "should get destroy" do
    get food_trades_destroy_url
    assert_response :success
  end

  test "should get update" do
    get food_trades_update_url
    assert_response :success
  end

end
