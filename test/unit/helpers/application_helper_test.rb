require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
   test "numbers coloring" do
     assert_equal "green", get_success_color(0.99)
     assert_equal "yellow", get_success_color(0.6)
     assert_equal "red", get_success_color(0.2)
  end
end
