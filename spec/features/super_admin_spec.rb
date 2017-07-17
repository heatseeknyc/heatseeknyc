require "spec_helper"

feature "Super User" do
  let(:tenant) { FactoryGirl.create(:user) }
  let(:advocate) { FactoryGirl.create(:user, :advocate) }

  context "login" do
    before(:each) do
      FactoryGirl.create(:collaboration, user: advocate, collaborator: tenant)
      login_as_super_user
    end

    context "goes to any tenant show page" do
      it "shows tenant name and export links" do
        visit user_path(tenant)
        expect(page).to have_content tenant.name
        expect(page).to have_link("PDF", href: pdf_download_path(tenant))
        expect(page).to have_link("CSV", href: csv_download_path(tenant))
      end
    end

    context "goes to an advocate page" do
      it "can go to tenant edit page" do
        visit user_path(advocate)
        first(".fa-wrench").click
        expect(current_path).to eq(edit_user_path(id: tenant.id))
      end

      it "can remove collaborator" do
        visit user_path(advocate)
        expect(page.all(".fa-times").length).to eq 1
      end
    end

    context "create new user" do
      it "submit form " do
        visit new_user_path
        fill_in "First name", with: "Oscar"
        fill_in "Last name", with: "Grouch"
        fill_in "Address", with: "123 Sesame St"
        fill_in "Apartment", with: "2H"
        fill_in "Phone number", with: "555-555-5555"
        fill_in "Zip code", with: "99999"
        fill_in "Email", with: "oscar@sesamestreet.com"
        fill_in "Password", with: "password"
        fill_in "Password confirmation", with: "password"
        click_on "Create User"

        expect(page.current_path).to eq users_path
        expect(page).to have_content("Oscar Grouch")
      end
    end

    context "edit existing user" do
      it "submit form " do
        visit edit_user_path(tenant)
        fill_in "First name", with: "Big"
        fill_in "Last name", with: "Bird"
        fill_in "Address", with: "321 Sesame St"
        fill_in "Apartment", with: "1H"
        fill_in "Phone number", with: "555-555-5555"
        fill_in "Zip code", with: "99999"
        select "team_member", from: "Permissions"
        click_on "SAVE"

        expect(page.current_path).to eq user_path(tenant)
        visit users_path
        expect(page).to have_content("Big Bird")
      end
    end

    context "set permission level of another user" do
      it "can set permission level to super user" do
        visit edit_user_path(advocate)
        select "super_user", from: "Permissions"
        expect(page).to have_select("Permissions", selected: 'super_user')
        click_on "SAVE"
        visit edit_user_path(advocate)
        assert has_no_select?("Permissions")
      end

      it "can set permission level to team member" do
        visit edit_user_path(advocate)
        select "team_member", from: "Permissions"
        expect(page).to have_select("Permissions", selected: 'team_member')
        click_on "SAVE"
        visit edit_user_path(advocate)
        expect(page).to have_select("Permissions", selected: 'team_member')
      end

      it "can set permission level to admin" do
        visit edit_user_path(advocate)
        select "admin", from: "Permissions"
        expect(page).to have_select("Permissions", selected: 'admin')
        click_on "SAVE"
        visit edit_user_path(advocate)
        expect(page).to have_select("Permissions", selected: 'admin')
      end

      it "can set permission level to advocate" do
        visit edit_user_path(tenant)
        select "advocate", from: "Permissions"
        expect(page).to have_select("Permissions", selected: 'advocate')
        click_on "SAVE"
        visit edit_user_path(tenant)
        expect(page).to have_select("Permissions", selected: 'advocate')
      end

      it "can set permission level to user" do
        visit edit_user_path(advocate)
        select "user", from: "Permissions"
        expect(page).to have_select("Permissions", selected: 'user')
        click_on "SAVE"
        visit edit_user_path(advocate)
        expect(page).to have_select("Permissions", selected: 'user')
      end
    end
  end
end
