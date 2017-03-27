require "spec_helper"

describe "Lawyer's Tenant Dashboard", type: :feature do
  let!(:admin) { login_as_admin }

  let(:user_with_no_violations) { FactoryGirl.create(:user) }
  let(:user_with_recent_violations1) { FactoryGirl.create(:user) }
  let(:user_with_recent_violations2) { FactoryGirl.create(:user) }
  let(:user_with_old_violations) { FactoryGirl.create(:user) }

  before do
    FactoryGirl.create(:collaboration, user: admin, collaborator: user_with_no_violations)
    FactoryGirl.create(:collaboration, user: admin, collaborator: user_with_recent_violations1)
    FactoryGirl.create(:collaboration, user: admin, collaborator: user_with_recent_violations2)
    FactoryGirl.create(:collaboration, user: admin, collaborator: user_with_old_violations)

    create_violation(user_with_old_violations, 5.days.ago)

    create_violation(user_with_recent_violations1, 5.days.ago)
    create_violation(user_with_recent_violations1, 2.days.ago)
    create_violation(user_with_recent_violations1, 2.days.ago)
    create_violation(user_with_recent_violations1, 1.days.ago)
    create_reading(user_with_recent_violations1, 77)

    create_violation(user_with_recent_violations2, 2.days.ago)
    create_reading(user_with_recent_violations2, 78)
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
      other_user = FactoryGirl.create(:user)
      create_violation(other_user, 2.days.ago)
      create_violation(other_user, 1.days.ago)

      visit user_path(admin)

      expect(page).to_not have_text other_user.name
    end
  end

  context "violations report" do
    it "shows all collaborators" do
      visit user_path(admin)

      within ".violations-report" do
        expect(page.all("tbody tr").length).to be 4
        expect(page.all("tbody tr td a.fa-times").length).to be 4
        expect(page.all("tbody tr td a.fa-wrench").length).to be 4
        expect(page).to have_text expected_text_for(user_with_recent_violations1, 3)
        expect(page).to have_text expected_text_for(user_with_recent_violations2, 1)
        expect(page).to have_text expected_text_for(user_with_no_violations, 0)
        expect(page).to have_text expected_text_for(user_with_old_violations, 0)
      end

      admin.update(permissions: User::PERMISSIONS[:lawyer])
      visit user_path(admin)
      within ".violations-report" do
        expect(page.all("tbody tr td a.fa-times").length).to be 4
        expect(page.all("tbody tr td a.fa-wrench").length).to be 0
      end
    end
  end

  def create_violation(user, time)
    FactoryGirl.create(:reading, user: user, created_at: time, outdoor_temp: 30, temp: 30)
  end

  def create_reading(user, temp)
    FactoryGirl.create(:reading, user: user, created_at: 1.hour.ago, outdoor_temp: 32, temp: temp)
  end

  def expected_text_for(user, violations_count)
    return "#{user.name} #{user.address}, #{user.zip_code} #{violations_count} #{user.current_temp}"
  end
end
