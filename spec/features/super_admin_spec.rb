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

        expect(page).to have_content("Oscar Grouch")
        expect(page.current_path).to eq users_path
      end
    end
  end
end
