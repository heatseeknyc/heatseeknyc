require "spec_helper"

describe "Send Email to advocates about new tenants", type: :feature do
  let!(:super_user) { login_as_super_user }
  let(:old_tenant) { FactoryBot.create(:tenant) }
  let(:advocate) { FactoryBot.create(:advocate) }



  before do
    FactoryBot.create(:collaboration, user: advocate, collaborator: old_tenant, created_at: 1.week.ago)
  end

  context "logged in super user" do
    it "should see email button for advocate with new tenants" do
      new_tenant = FactoryBot.create(:tenant)
      FactoryBot.create(:collaboration, user: advocate, collaborator: new_tenant)
      visit users_path
      expect(page).to have_content advocate.name
      expect(page).to have_css(".fa-envelope")
    end

    it "should not see email button for advocate with no new tenants" do
      visit users_path
      expect(page).to have_content advocate.name
      expect(page).to_not have_css(".fa-envelope")
    end

    it "should see email has been sent to advocate after click" do
      new_tenant = FactoryBot.create(:tenant)
      FactoryBot.create(:collaboration, user: advocate, collaborator: new_tenant)
      visit users_path
      first(".fa-envelope").click
      expect(page).to have_content new_tenant.email
      expect(page).to_not have_content old_tenant.email
    end
  end

end
