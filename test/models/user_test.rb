require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  	@user = User.new(name: "Foobar", email: "foo@bar.com", 
                     password: "foobar", password_confirmation: "foobar")
  end

  test "user is valid" do
  	assert @user.valid?
  end

  test "name is valid" do
  	@user.name = "     "
  	assert_not @user.valid?
  end

  test "email is valid" do 
  	@user.email = "     "
  	assert_not @user.valid?
  end

  test "name is not too long" do
  	@user.name = "x" * 51
  	assert_not @user.valid?
  end

  test "email is not too long" do
  	@user.email = "x" * 245 + "@foobar.com"
  	assert_not @user.valid?
  end

  test "email accepts valid address" do
  	# valid_address = new String[]
  	valid_addresses = %w[foo@bar.com FOO@bar.COM F_O-O@b.a.r.org 
  						foo.bar@foo.jz foo+bar@foobar.cn]
  	valid_addresses.each do |valid_address| 		#for each string address in array
  		@user.email = valid_address 				#user.email = address
  		assert @user.valid?, 						#assert validation
  		"#{valid_address.inspect} should be valid" 	#print
  	end
  end

  test "email rejects invalid address" do 
  	invalid_addresses = %w[foo@bar,com foo.bar.org foo@bar 
  						foobar@foo_bar.com foo@foo+bar.com]
  	invalid_addresses.each do |invalid_address|
  		@user.email = invalid_address
  		assert_not @user.valid?, 
  		"#{invalid_address.inspect} should be invalid"
  	end
  end

  test "email addresses are unique" do
  	#create duplicate user with same email
  	#save duplicate user in DB
  	#emails should be unique, therefore not valid
  	duplicate_user = @user.dup
  	duplicate_user.email = @user.email.upcase		#emails should not be case sensitive
  	@user.save
  	assert_not duplicate_user.valid?
  end

  test "email saved as lowercase" do
  	mixed_case_email = "FoO@bAr.CoM"
  	@user.email = mixed_case_email
  	@user.save
  	#use assert_equal to compare downcased sample email and user.email in DB record
  	assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password is present (not blank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password has minimum length" do 
    @user.password = @user.password_confirmation = " " * 5
    assert_not @user.valid?
  end
end
