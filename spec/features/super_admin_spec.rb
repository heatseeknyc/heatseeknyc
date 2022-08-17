require "spec_helper"

feature "Super User" do
  let(:tenant) { FactoryBot.create(:user) }
  let(:advocate) { FactoryBot.create(:user, :advocate) }

  context "login" do
    before(:each) do
      FactoryBot.create(:collaboration, user: advocate, collaborator: tenant)
      FactoryBot.create(:reading, user: tenant, created_at: DateTime.new(2018, 12, 1))
      login_as_super_user
    end

    context "goes to any tenant show page" do
      it "shows tenant name and export links" do
        visit user_path(tenant)
        expect(page).to have_content tenant.name
        expect(page).to have_link("CSV", href: csv_download_path(tenant))
        expect(page).to have_link("PDF 2018 - 2019")
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

        expect(page).to have_content("Oscar Grouch")
        expect(page.current_path).to eq users_path
      end
    end
  end
end
