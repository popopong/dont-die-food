require 'test_helper'

class UserOwnedIngredientsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get user_owned_ingredients_create_url
    assert_response :success
  end

  test "should get destroy" do
    get user_owned_ingredients_destroy_url
    assert_response :success
  end

end
