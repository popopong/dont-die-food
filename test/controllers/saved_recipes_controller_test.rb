require 'test_helper'

class SavedRecipesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get saved_recipes_create_url
    assert_response :success
  end

end
