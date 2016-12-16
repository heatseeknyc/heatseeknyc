require 'spec_helper'

describe "Violations report" do
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

    FactoryGirl.create(:reading, user: user_with_old_violations)

    create_violation(user_with_old_violations, 5.days.ago)

    create_violation(user_with_recent_violations1, 5.days.ago)
    create_violation(user_with_recent_violations1, 2.days.ago)
    create_violation(user_with_recent_violations1, 2.days.ago)
    create_violation(user_with_recent_violations1, 1.days.ago)

    create_violation(user_with_recent_violations2, 2.days.ago)
  end

  it "It shows users who have had violations in the last 3 days" do
    visit user_path(admin)

    expect(page).to have_text user_with_no_violations.name
    expect(page).to have_text user_with_recent_violations1.name
    expect(page).to have_text user_with_recent_violations2.name
    expect(page).to have_text user_with_old_violations.name

    within ".violations-report" do
      expect(page).to have_text "#{user_with_recent_violations1.name} 3"
      expect(page).to have_text "#{user_with_recent_violations2.name} 1"

      expect(page).to_not have_text user_with_no_violations.name
      expect(page).to_not have_text user_with_old_violations.name
    end
  end

  def create_violation(user, time)
    FactoryGirl.create(:reading, user: user, created_at: time, outdoor_temp: 30, temp: 30)
  end
end
