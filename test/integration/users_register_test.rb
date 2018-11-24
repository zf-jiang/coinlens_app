require 'test_helper'

class UsersRegisterTest < ActionDispatch::IntegrationTest
  test "invalid register inputs" do 
  	get register_path
  	assert_no_difference 'User.count' do	#assertion: user count should not change 
=begin
	count_before = User.count
	POST users_path
	count_after = User.count
	assert_equal count_before, count_after
=end
  	 post users_path, params: { user: { 	name: 					        "",
  										   	                email: 					        "foobar@invalid",
  											                  password: 				      "foo",
  											                  password_confirmation: 	"bar" } }
  	end
  assert_template 'users/new' #returns to register page upon failed registration
  end

  test "valid registration" do
    get register_path
    assert_difference 'User.count', 1 do  #assertion: user count should increase by 1
      post users_path, params: { user: {  name:                   "Foo Bar",
                                          email:                  "foo@bar.com",
                                          password:               "foobar",
                                          password_confirmation:  "foobar" } }
    end
    follow_redirect!
    assert_template 'users/show'  #successful registration redirects to user profile
    assert is_logged_in?
  end
end
