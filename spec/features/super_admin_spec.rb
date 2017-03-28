require "spec_helper"

feature "Super User" do
  let(:tenant) { create(:tenant) }

  context "after successful login" do
    before(:each) do
      login_as_super_user
    end

    scenario "goes to any tenant show page" do
      visit user_path(tenant)

      expect(page).to have_content tenant.name
      expect(page).to have_link("PDF", href: pdf_download_path(tenant))
      expect(page).to have_link("CSV", href: csv_download_path(tenant))
    end
  end
end
