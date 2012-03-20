require 'test_helper'

class GraphsControllerTest < ActionController::TestCase
  test "html request to the graph should be workable" do
    get :index
    assert_response :success
    assert_not_nil assigns(:graph)
 end

  test "json request to the graph should be workable" do
    get :index, :format => "json"
    assert_response :success
 end
end
