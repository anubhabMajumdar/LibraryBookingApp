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

  test "name cannot be more than 80 characters" do
    @user.name = "a"*81
    assert_not @user.valid?
  end

  test "name cannot have special characters" do
    @user.name = "anubhab@ majumdar"
    assert_not @user.valid?
  end

  test "name cannot have numbers" do
    @user.name = "anubhab92 majumdar"
    assert_not @user.valid?
  end


  test "email cannot be blank" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "email cannot be more than 100 characters" do
    @user.email = ("a"*100 + "@blah.com")
    assert_not @user.valid?
  end

  test "email should have proper semantics 1" do
    @user.email = "@blah.com"
    assert_not @user.valid?
  end

  test "email should have proper semantics 2" do
    @user.email = "anubhab#majumdar@blah.com"
    assert_not @user.valid?
  end

  test "email should have proper semantics 3" do
    @user.email = "anubhab#majumdar@blah..com"
    assert_not @user.valid?
  end

end
