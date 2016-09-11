require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "Anubhab Majumdar", email: "amajumd@ncsu.edu", Password_digest: "jhwxhjhwjxh247478", Admin: true)
  end

  test "sanity check - should pass" do
    assert @user.valid?
  end

  test "name cannot be blank" do
    @user.name = " "
    assert_not @user.valid?
  end

end
