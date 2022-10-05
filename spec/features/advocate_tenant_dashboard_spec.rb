require "spec_helper"

describe "Advocate's Tenant Dashboard", type: :feature do
  let!(:admin) { login_as_admin }

  let(:user_with_no_violations) { FactoryBot.create(:user) }
  let(:user_with_recent_violations1) { FactoryBot.create(:user) }
  let(:user_with_recent_violations2) { FactoryBot.create(:user) }
  let(:user_with_old_violations) { FactoryBot.create(:user) }

  before do
    FactoryBot.create(:collaboration, user: admin, collaborator: user_with_no_violations)
    FactoryBot.create(:collaboration, user: admin, collaborator: user_with_recent_violations1)
    FactoryBot.create(:collaboration, user: admin, collaborator: user_with_recent_violations2)
    FactoryBot.create(:collaboration, user: admin, collaborator: user_with_old_violations)

    FactoryBot.create(:reading, :violation, user: user_with_old_violations, created_at: 8.days.ago)

    FactoryBot.create(:reading, :violation, user: user_with_recent_violations1, created_at: 8.days.ago)
    FactoryBot.create(:reading, :violation, user: user_with_recent_violations1, created_at: 2.days.ago)
    FactoryBot.create(:reading, :violation, user: user_with_recent_violations1, created_at: 2.days.ago)
    FactoryBot.create(:reading, :violation, user: user_with_recent_violations1, created_at: 1.days.ago)

    FactoryBot.create(:reading, user: user_with_recent_violations1, temp: 77)

    FactoryBot.create(:reading, :violation, user: user_with_recent_violations2, created_at: 2.days.ago)
    FactoryBot.create(:reading, user: user_with_recent_violations2, temp: 78)
  end

  context "violation table" do
    it "shows user information for all associated tenants" do
      visit user_path(admin)

      within "#append-violations" do
        expect(page).to have_text user_with_no_violations.name
        expect(page).to have_text user_with_recent_violations1.name
        expect(page).to have_text user_with_recent_violations2.name
        expect(page).to have_text user_with_old_violations.name
      end
    end

    it "does not show users you are not associated with" do
      other_user = FactoryBot.create(:user)
      FactoryBot.create(:reading, :violation, user: other_user, created_at: 2.days.ago)
      FactoryBot.create(:reading, :violation, user: other_user, created_at: 1.days.ago)

      visit user_path(admin)

      expect(page).to_not have_text other_user.name
    end
  end

  context "violations report" do
    it "shows all collaborators" do
      visit user_path(admin)

      within ".styled-table" do
        expect(page.all("tbody tr").length).to be 4
        expect(page.all("tbody tr td a.fa-times").length).to be 4
        expect(page.all("tbody tr td a.fa-wrench").length).to be 4
        expect(page).to have_text expected_text_for(user_with_recent_violations1, 3)
        expect(page).to have_text expected_text_for(user_with_recent_violations2, 1)
        expect(page).to have_text expected_text_for(user_with_no_violations, 0)
        expect(page).to have_text expected_text_for(user_with_old_violations, 0)
      end

      admin.update(permissions: User::PERMISSIONS[:advocate])
      visit user_path(admin)
      within ".styled-table" do
        expect(page.all("tbody tr td a.fa-times").length).to be 4
        expect(page.all("tbody tr td a.fa-wrench").length).to be 0
      end
    end
  end

  def expected_text_for(user, violations_count)
    return "#{user.name} #{user.address}, #{user.zip_code} #{violations_count} #{user.current_temp}"
  end
end
