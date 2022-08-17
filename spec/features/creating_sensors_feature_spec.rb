require "spec_helper"

describe "creating a sensor", type: :feature do
  before(:each) do
    @admin = create(:user, {
      first_name: "Jason", 
      last_name: "Smith", 
      email: "jason@email.com", 
      password: "password",
      permissions: 0
    })

    @tenant = create(:user, {
      first_name: "Rebecca", 
      last_name: "Jones",
      email: "rebecca@email.com", 
      password: "password",
      permissions: 100
    })

    logout :user
    login_as @admin, scope: :user
  end

  it "displays the sensor after creation" do
    visit new_sensor_path
    fill_in :sensor_name, with: "12345678"
    fill_in :sensor_nick_name, with: "ABCD"
    select "Jones, Rebecca <rebecca@email.com>", from: "sensor_user_id"
    click_on "Create Sensor"

    sensor = Sensor.last
    expect(sensor.name).to eq "12345678"
    expect(sensor.user.email).to eq "rebecca@email.com"

    expect(page.current_path).to eq sensor_path(id: sensor.id)
    expect(page).to have_content "12345678"
    expect(page).to have_content "rebecca@email.com"
  end

  it "displays sensor after updating" do
    sensor = FactoryBot.create(:sensor)

    visit edit_sensor_path(id: sensor.id)
    select "Jones, Rebecca <rebecca@email.com>", from: "sensor_user_id"
    click_on "Update Sensor"

    expect(page.current_path).to eq sensors_path
    expect(page).to have_content sensor.name
    expect(page).to have_content "Jones, Rebecca"
  end
end
