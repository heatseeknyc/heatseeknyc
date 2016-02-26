require 'spec_helper'

describe User do
  it "has apartment" do
    pat = create(:user)
    pat.apartment = '2H'
    expect(pat.apartment).to eq '2H'
  end

  it "has telephone" do
    pat = create(:user)
    pat.phone_number = '555-555-5555'
    expect(pat.phone_number).to eq '555-555-5555'
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
			expect(user2.most_recent_temp).to eq(last_reading.temp)
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

	describe "user permissions" do 
		it "can be a demo user" do
			user7 = create(:user, email: 'demo-lawyer@heatseeknyc.com')
			expect(user7.is_demo_user?).to be(true)
		end

		it "understands permissions" do
			admin = create(:user, permissions: 25)
			lawyer = create(:user, permissions: 50)
			user8 = create(:user)
			expect(admin.admin?).to be(true)
			expect(lawyer.lawyer?).to be(true)
			expect(user8.admin?).to be(false)
			expect(user8.lawyer?).to be(false)
		end
	end

  describe "sensor_codes_string" do
    it "allows user save if corresponding sensors exist" do
      create(:sensor, nick_name: '0000')
      user = create(:user)
      user.sensor_codes_string = '0000'
      expect(user.save).to be_true
    end

    it "prevents user save if no corresponding sensors exist" do
      user = create(:user)
      user.sensor_codes_string = '0000'
      expect(user.save).to be_false
    end
  end
end
