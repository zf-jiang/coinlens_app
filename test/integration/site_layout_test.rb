require 'test_helper'
require 'rails-controller-testing'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
  	get root_path
  	assert_template 'static_pages/home'
  	assert_select "a[href=?]", root_path, count: 2
  	assert_select "a[href=?]", about_path
  	assert_select "a[href=?]", features_path
  	assert_select "a[href=?]", register_path
  	assert_select "a[href=?]", login_path
  	assert_select "a[href=?]", contact_path
  end
end
