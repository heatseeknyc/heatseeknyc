require "spec_helper"

describe "creating a sensor", type: :feature do
  before(:each) do
    @admin = create(:user, {
      first_name: "Jason", 
      email: "jason@email.com", 
      password: "password",
      permissions: 0
    })

    @tenant = create(:user, {
      first_name: "Rebecca", 
      email: "rebecca@email.com", 
      password: "password",
      permissions: 100
    })
  end

  it "displays the sensor after creation" do
    logout :user
    login_as @admin, scope: :user
    
    visit new_sensor_path
    fill_in :sensor_name, with: "12345678"
    fill_in :sensor_email, with: "rebecca@email.com"
    click_on "Create Sensor"
    
    sensor = Sensor.last
    expect(sensor.name).to eq "12345678"
    expect(sensor.user.email).to eq "rebecca@email.com"
    expect(page).to have_content "12345678"
    expect(page).to have_content "rebecca@email.com"
  end
end
