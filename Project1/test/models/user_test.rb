require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Anubhab Majumdar",
                     email: "amajumd@ncsu.edu",
                     password: "blahblah93@",
                     password_confirmation: "blahblah93@",
                     Admin: true)
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

  test "email should be unique" do
    user_copy = @user.dup
    @user.save
    assert_not user_copy.valid?
  end

  test "password should not be blank" do
    @user.password = " "
    @user.password_confirmation = " "
    assert_not @user.valid?
  end

  test "password should have minimum length" do
    @user.password = "anubh"
    @user.password_confirmation = "anubh"
    assert_not @user.valid?
  end

  test "password should have one number and one special character" do
    @user.password = "anubhab"
    @user.password_confirmation = "anubhab"
    assert_not @user.valid?
  end


end
