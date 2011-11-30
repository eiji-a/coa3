require 'test_helper'

class TagTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  test "get method" do
    tag = Tag.new
    tag.name = 'H'
    tag.user_id = 1
    tag.save

    tag2 = Tag.get('H', 1)
    assert_equal tag2.name, 'H'
  end
end
