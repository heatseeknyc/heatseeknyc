def login_as_tenant
  user = create(:user)
  visit new_user_session_path
  fill_in :user_email, with: user.email
  fill_in :user_password, with: user.password
  click_on "Sign in"
  return user
end

def expect_nav_bar
  expect(page).to have_link("About")
  expect(page).to have_link("blog", href: blog_path)    
  expect(page).to have_link("Cold Map", href: coldmap_path)    
  expect(page).to have_link("Demo", href: demo_path)
  expect(page).to have_link("Account") 
end