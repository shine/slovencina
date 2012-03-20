require 'test_helper'

class StatisticsControllerTest < ActionController::TestCase
  test "html request to statistics should be workable" do
    get :index
    
    assert_response :success
    assert_not_nil assigns(:words)
    assert_not_nil assigns(:total_attempts)
    assert_not_nil assigns(:total_good_attempts)
    assert_not_nil assigns(:total_good_attempts_percent)
 end
 
  test "shame list for period should be workable. id is number of days before current" do
    get :show, :id => 2
    
    assert_response :success
    assert_not_nil assigns(:words)
    assert_not_nil assigns(:stats)
 end
end
