require 'spec_helper'

describe User, :vcr do
  describe "#inspect" do
    let(:rick) do
      create(
        :user,
        first_name: "Rick",
        last_name: "Sanchez",
        email: "rick@rickandmorty.com",
        phone_number: nil
      )
    end

    it "excludes identifying information when in anonymized mode" do
      expect(rick.inspect).to include "first_name: \"#{rick.first_name}\""
      expect(rick.inspect).to include "search_first_name: \"#{rick.search_first_name}\""
      expect(rick.inspect).to include "last_name: \"#{rick.last_name}\""
      expect(rick.inspect).to include "search_last_name: \"#{rick.search_last_name}\""
      expect(rick.inspect).to include "apartment: \"#{rick.apartment}\""
      expect(rick.inspect).to include "email: \"#{rick.email}\""
      expect(rick.inspect).to include "phone_number: nil"
      ENV["ANONYMIZED_FOR_LIVESTREAM"] = "TRUE"
      expect(rick.inspect).to_not include "first_name: \"#{rick.first_name}\""
      expect(rick.inspect).to_not include "search_first_name: \"#{rick.search_first_name}\""
      expect(rick.inspect).to_not include "last_name: \"#{rick.last_name}\""
      expect(rick.inspect).to_not include "search_last_name: \"#{rick.search_last_name}\""
      expect(rick.inspect).to_not include "apartment: \"#{rick.apartment}\""
      expect(rick.inspect).to_not include "email: \"#{rick.email}\""
      expect(rick.inspect).to_not include "phone_number: nil"
    end

    it "includes non-identifying information" do
      expect(rick.inspect).to include "id: #{rick.id}"
      expect(rick.inspect).to include "address: \"#{rick.address}\""
      expect(rick.inspect).to include "permissions: #{rick.permissions}"
    end
  end

  it "has apartment" do
    pat = create(:user)
    pat.apartment = "2H"
    expect(pat.apartment).to eq "2H"
  end

  it "has telephone" do
    pat = create(:user)
    pat.phone_number = "555-555-5555"
    expect(pat.phone_number).to eq "555-555-5555"
  end

	describe "has a twine" do
		it "can have a twine" do
			twine1 = create(:twine)
			user1 = create(:user)
			user1.twine_name = twine1.name
			expect(user1.twine_name).to eq("TestTwine1")
		end

		it "can view readings" do
			user2 = create(:user)
			twine = create(:twine, :user_id => user2.id)
			reading1 = create(:reading, twine: twine, :user_id => user2.id)
			reading2 = create(:reading, twine: twine, :user_id => user2.id)
			last_reading = create(:reading, twine: twine, :user_id => user2.id)
			expect(user2.current_temp).to eq(last_reading.temp)
			expect(user2.has_readings?).to be(true)
		end
	end

	describe "user collaborations" do 
		it "knows about its collaborations" do
			user3 = create(:user, permissions: 100)
			user4 = create(:user, permissions: 50)
			collaboration = create(:collaboration, :user_id => user3.id, :collaborator_id => user4.id)
			expect(user3.has_collaboration?(collaboration.id)).to be(true)
			expect(user4.has_collaboration?(collaboration.id)).to be(false)
		end

		it "can destroy its collaborations" do
			user5 = create(:user, permissions: 50)
			user6 = create(:user, permissions: 100)
			collaboration = create(:collaboration, :user_id => user5.id, :collaborator_id => user6.id)
			user6.destroy_all_collaborations
			expect(user6.has_collaboration?(collaboration.id)).to be(false)
		end
  end

  describe "collaborations_with_violations" do
    let(:lawyer) { create(:user, permissions: 50) }
    let(:tenant_with_violations) { create(:user, permissions: 100) }
    let(:tenant_with_no_violations) { create(:user, permissions: 100) }
    let(:tenant_with_old_violations) { create(:user, permissions: 100) }

    before(:each) do
      create(:collaboration, :user_id => lawyer.id, :collaborator_id => tenant_with_no_violations.id)

      create(:collaboration, :user_id => lawyer.id, :collaborator_id => tenant_with_violations.id)
      create(:reading, :violation, user: tenant_with_violations)

      create(:collaboration, :user_id => lawyer.id, :collaborator_id => tenant_with_old_violations.id)
      create(:reading, :violation, user: tenant_with_old_violations, created_at: 5.days.ago)
    end

    it "finds all collaborations" do
      expect(lawyer.collaborations_with_violations.length).to be 3
    end

    it "includes violation_count" do
      collaborations = lawyer.collaborations_with_violations
      expect(collaborations.find_by(collaborator: tenant_with_no_violations).violations_count).to be 0
      expect(collaborations.find_by(collaborator: tenant_with_violations).violations_count).to be 1
      expect(collaborations.find_by(collaborator: tenant_with_old_violations).violations_count).to be 0
    end

    it "orders collaborations by violation count" do
      violations_counts = lawyer.collaborations_with_violations.to_ary.map(&:violations_count)
      expect(violations_counts.sort.reverse).to eq violations_counts
    end
  end

	describe "user permissions" do 
		it "can be a demo user" do
			user7 = create(:user, email: 'demo-lawyer@heatseeknyc.com')
			expect(user7.is_demo_user?).to be(true)
		end

		it "understands permissions" do
			admin = create(:user, permissions: 25)
			lawyer = create(:user, permissions: 50)
			user8 = create(:user)
			expect(admin.admin_or_more_powerful?).to be(true)
			expect(lawyer.lawyer?).to be(true)
			expect(user8.admin_or_more_powerful?).to be(false)
			expect(user8.lawyer?).to be(false)
		end
	end

  describe "sensor_codes_string" do
    it "allows user save if corresponding sensors exist" do
      pending

      create(:sensor, nick_name: '0000')
      user = create(:user)
      user.sensor_codes_string = '0000'
      expect(user.save).to be_true
    end

    it "prevents user save if no corresponding sensors exist" do
      pending

      user = create(:user)
      user.sensor_codes_string = '0000'
      expect(user.save).to be_false
    end
  end

  describe "#list_permission_level_and_lower" do
    it "returns permission levels that are less than or equal to the user" do
      user = create(:admin)
      expect(user.list_permission_level_and_lower).to eq(
        admin: 25,
        lawyer: 50,
        user: 100
      )
    end

    it "should not include permission levels that are higher" do
      user = create(:admin)
      permissions_hash = user.list_permission_level_and_lower
      expect(permissions_hash[:super_user]).to be_nil
      expect(permissions_hash[:team_member]).to be_nil
    end
  end

  describe "unit and building associations" do
    let(:user) { create(:user) }

    it "has a unit association" do
      unit = create(:unit)
      unit.tenants << user
      expect(user.unit).to eq(unit)
    end
  end

  describe "#get_oldest_reading_date" do
    let(:user) { create(:user) }

    it "returns the date of the first reading associated with the user" do
      oldest_date = Date.parse("2013-10-29")

      create(:reading, :user_id => user.id, :created_at => oldest_date)
      create(:reading, :user_id => user.id, :created_at => oldest_date + 3.days)

      expect(user.get_oldest_reading_date("(since %m/%d/%y)")).to eq("(since 10/29/13)")
    end

    it "returns nil when the user has no readings" do
      expect(user.get_oldest_reading_date("(since %m/%d/%y)")).to eq(nil)
    end
  end

  describe "#get_newest_reading_date" do
    let(:user) { create(:user) }

    it "returns the date of the first reading associated with the user" do
      newest_date = Date.parse("2013-10-29")

      create(:reading, :user_id => user.id, :created_at => newest_date)
      create(:reading, :user_id => user.id, :created_at => newest_date - 3.days)

      expect(user.get_newest_reading_date("(since %m/%d/%y)")).to eq("(since 10/29/13)")
    end

    it "returns nil when the user has no readings" do
      expect(user.get_newest_reading_date("(since %m/%d/%y)")).to eq(nil)
    end
  end

  describe "#current_temp" do
    let(:user) { create(:user) }

    context "when user has readings" do
      let!(:reading) { create(:reading, user: user, temp: 64) }

      it "returns the last reading's temperature" do
        expect(user.current_temp).to eq(reading.temp)
      end
    end

    context "when user has no readings" do
      it "returns nil" do
        expect(user.current_temp).to be_nil
      end
    end
  end
end
