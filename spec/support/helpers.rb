def login_as_type(type, options = {})
  user = create(type, options)
  visit new_user_session_path
  fill_in :user_email, with: user.email
  fill_in :user_password, with: user.password
  click_on "Sign in"
  return user
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

def expect_pre_filled_settings_for(user)
  expect(page).to have_content "First name"
  expect(page).to have_selector("input[value='#{user.first_name}']")

  expect(page).to have_content "Last name"
  expect(page).to have_selector("input[value='#{user.last_name}']")

  expect(page).to have_content "Address"
  expect(page).to have_selector("input[value='#{user.address}']")

  expect(page).to have_content "Zip code"
  expect(page).to have_selector("input[value='#{user.zip_code}']")

  expect(page).to have_content "Email"
  expect(page).to have_selector("input[value='#{user.email}']")
end
