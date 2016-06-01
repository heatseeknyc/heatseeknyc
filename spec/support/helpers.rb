def login_as_type(type, options = {})
  user = create(type, options)
  visit new_user_session_path
  fill_in :user_email, with: user.email
  fill_in :user_password, with: user.password
  click_on "Sign in"
  return user
end

def login_as_team_member
  login_as_type(:team_member)
end

def login_as_admin
  login_as_type(:admin)
end

def login_as_tenant(options = {})
  login_as_type(:tenant, options)
end

def expect_nav_bar
  expect(page).to have_link("About")
  expect(page).to have_link("blog", href: blog_path)
  expect(page).to have_link("Cold Map", href: coldmap_path)
  expect(page).to have_link("Demo", href: demo_path)
  expect(page).to have_link("Account")
end
