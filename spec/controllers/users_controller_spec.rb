require 'spec_helper'

describe UsersController, type: :controller do
  let(:tenant) { create(:user) }
  let(:stranger) { create(:user) }
  let(:advocate) { create(:user, permissions: User::PERMISSIONS[:advocate]) }
  let(:admin) { create(:user, permissions: User::PERMISSIONS[:admin]) }
  let(:team_member) { create(:user, permissions: User::PERMISSIONS[:team_member]) }
  let(:super_user) { create(:user, permissions: User::PERMISSIONS[:super_user]) }
  let(:stranger_admin) { create(:user, permissions: User::PERMISSIONS[:admin]) }

  describe "GET /users/:id" do
    context "when current user is a tenant" do

      before :each do
        sign_in tenant
      end

      context "and they visit their own page" do
        it "shows their graph page" do
          get :show, params: { id: tenant.id }
          expect(response.status).to eq(200)
        end
      end

      context "and they visit another user" do
        it "shows their graph page" do
          get :show, params: { id: stranger.id }
          expect(response).to redirect_to(user_path(tenant))
        end
      end
    end

    context "when current user is an advocate" do
      before :each do
        advocate.collaborators << tenant
        advocate.save
        sign_in advocate
      end

      context "and they visit a tenant with whom they collaborate" do
        it "shows the tenant's show page" do
          get :show, params: { id: tenant.id }
          expect(response.status).to eq(200)
          expect(response).to render_template "show"
        end
      end

      context "and they visit a tenant with whom they do not collaborate" do
        it "redirects to their own page" do
          get :show, params: { id: stranger.id }
          expect(response).to redirect_to(user_path(advocate))
        end
      end
    end

    context "when current user is an admin" do
      before :each do
        sign_in admin
      end

      context "and they visit their page" do
        it "shows their page" do
          get :show, params: { id: admin.id }
          expect(response.status).to eq(200)
          expect(response).to render_template "permissions_show"
        end
      end

      context "and they visit a tenant's page" do
        it "shows the tenant's show page" do
          get :show, params: { id: tenant.id }
          expect(response.status).to eq(200)
          expect(response).to render_template "show"
        end
      end

      context "and they visit an advocate's page" do
        it "shows the advocate page" do
          get :show, params: { id: advocate.id }
          expect(response.status).to eq(200)
          expect(response).to render_template "permissions_show"
        end
      end

      context "and they visit an admin's page" do
        it "redirects to the original admin's page" do
          get :show, params: { id: stranger_admin.id }
          expect(response).to redirect_to(user_path(admin))
        end
      end
    end

    context "when current user is a team member" do
      before :each do
        sign_in team_member
      end

      context "and they visit their page" do
        it "shows their page" do
          get :show, params: { id: team_member.id }
          expect(response.status).to eq(200)
          expect(response).to render_template "permissions_show"
        end
      end

      context "and they visit a tenant's page" do
        it "shows the tenant's show page" do
          get :show, params: { id: tenant.id }
          expect(response.status).to eq(200)
          expect(response).to render_template "show"
        end
      end

      context "and they visit an advocate's page" do
        it "shows the advocate page" do
          get :show, params: { id: advocate.id }
          expect(response.status).to eq(200)
          expect(response).to render_template "permissions_show"
        end
      end

      context "and they visit an admin's page" do
        it "redirects to their page" do
          get :show, params: { id: admin.id }
          expect(response).to redirect_to(user_path(team_member))
        end
      end
    end

    context "when current user is a super user" do
      before :each do
        sign_in super_user
      end

      context "and they visit their page" do
        it "shows their page" do
          get :show, params: { id: super_user.id }
          expect(response.status).to eq(200)
          expect(response).to render_template "permissions_show"
        end
      end

      context "and they visit a tenant's page" do
        it "shows the tenant's show page" do
          get :show, params: { id: tenant.id }
          expect(response.status).to eq(200)
          expect(response).to render_template "show"
        end
      end

      context "and they visit an advocate's page" do
        it "shows the advocate's page" do
          get :show, params: { id: advocate.id }
          expect(response.status).to eq(200)
          expect(response).to render_template "permissions_show"
        end
      end

      context "and they visit an admin's page" do
        it "shows the admin's page" do
          get :show, params: { id: admin.id }
          expect(response.status).to eq(200)
          expect(response).to render_template "permissions_show"
        end
      end

      context "and they visit an team members's page" do
        it "shows the admin's page" do
          get :show, params: { id: team_member.id }
          expect(response.status).to eq(200)
          expect(response).to render_template "permissions_show"
        end
      end
    end
  end

  describe "GET /users/:id/download/csv" do
    let(:csv_writer) { double('csv_writer') }
    let(:file) { double('file') }
    let(:filename) { "filename" }
    let(:content_type) { "csv" }

    before do
      allow(controller).to receive(:authenticate_user!)
      allow(CSVWriter).to receive(:new).with("1").and_return csv_writer
      allow(csv_writer).to receive(:generate_csv).and_return file
      allow(csv_writer).to receive(:filename)
      allow(controller).to receive(:send_data).
        with(file, filename: csv_writer.filename, type: "text/csv") { controller.render :body => nil }
    end

    it "instantiates a csv writer" do
      expect(CSVWriter).to receive(:new).with("1").and_return csv_writer
      get :download_csv, params: { id: 1 }
    end

    it "sends the data" do
      expect(csv_writer).to receive(:filename).and_return filename
      expect(controller).to receive(:send_data).
        with(file, filename: filename, type: "text/csv") { controller.render :body => nil }
      get :download_csv, params: { id: 1 }
    end
  end

  describe "GET /users/:id/edit" do
    it "should render the edit view for an admin user" do
      sign_in admin
      get :edit, params: { id: tenant }

      expect(response.status).to eq(200)
      expect(response).to render_template("edit")
    end

    it "should redirect a non-admin user to the root path" do
      sign_in tenant
      get :edit, params: { id: tenant }

      expect(response).to redirect_to(root_path)

      sign_in advocate
      get :edit, params: { id: tenant }

      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /users/:id/edit" do
    let(:params) { {id: tenant, user: {first_name: "Updated"}} }

    it "should update the resource if the request comes from an admin user" do
      admin.collaborations.create(collaborator: tenant)
      sign_in admin
      put :update, params: params

      expect(response).to redirect_to user_path(id: tenant.id)
      expect(tenant.reload.first_name).to eq("Updated")
    end

    it "should redirect a request from a non-admin user" do
      sign_in tenant
      put :update, params: params

      expect(response).to redirect_to(root_path)

      sign_in advocate
      put :update, params: params

      expect(response).to redirect_to(root_path)
    end

    describe "setting permission level" do
      it "restricts setting permissions level higher than ones own" do
        sign_in admin
        params[:user][:permissions] = User::PERMISSIONS[:team_member]
        put :update, params: params
        expect(response.status).to eq(401)
        expect(response.body).to eq("Unauthorized")
      end

      it "permits setting the same permission level as the admin user's" do
        sign_in admin
        params[:user][:permissions] = User::PERMISSIONS[:admin]
        put :update, params: params
        expect(response).to redirect_to user_path(tenant)
        expect(tenant.reload.permissions).to eq(User::PERMISSIONS[:admin])
      end
    end
  end

  describe "GET /users/edit_password" do
    context "user is logged in" do
      before { sign_in create(:user) }

      it "renders the edit_password form" do
        get :edit_password
        expect(response).to be_ok
        expect(response).to render_template("edit_password")
      end
    end

    context "user is not logged in" do
      it "redirects to sign in form" do
        get :edit_password
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /users/update_password" do
    context "user is logged in" do
      let(:user) { create(:user) }
      let(:new_pass) { "new_password" }
      let(:password_params) do
        {current_password: user.password,
          password: new_pass,
          password_confirmation: new_pass}
      end

      before { sign_in user }

      it "redirects to users path on update success" do
        patch :update_password, params: { user: password_params }
        expect(response).to redirect_to root_path
      end

      it "re-renders the edit form on update failure" do
        password_params[:current_password] = "bad password"
        patch :update_password, params: { user: password_params }
        expect(response.status).to eq(401)
        expect(response).to render_template("edit_password")
      end
    end

    context "user is not logged in" do
      it "redirects to sign in form" do
        patch :update_password
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /users/create" do
    let(:super_user) { create(:super_user) }

    before {
      sign_in super_user
      allow(UserMailer).to receive(:welcome_email).and_return double('UserMailer', deliver: true)
      allow_any_instance_of(User).to receive(:add_to_get_response)
    }

    it "redirects to users index on create success", :vcr do
      new_user = build(:user)
      post :create, params: { user: new_user.attributes.merge(password: 'password', password_confirmation: 'password') }

      expect(response).to redirect_to(users_path)
    end

    it "creates user and associates with existing building", :vcr do
      building = create(:building)
      new_user = build(:user, address: building.street_address, zip_code: building.zip_code)
      post :create, params: { user: new_user.attributes.merge(password: 'password', password_confirmation: 'password') }

      user = User.last
      expect(user.first_name).to eq(new_user.first_name)
      expect(user.last_name).to eq(new_user.last_name)
      expect(user.building).to eq(building)
    end

    it "creates user and trims whitespace from user input" do
      new_user = build(:user, address: " 123 Fake St ", first_name: "Kevin  ", last_name: "Tenant  ")
      post :create, params: { user: new_user.attributes.merge(password: 'password', password_confirmation: 'password') }

      user = User.last
      expect(user.first_name).to eq("Kevin")
      expect(user.last_name).to eq("Tenant")
      expect(user.address).to eq("123 Fake St")
    end

    describe "GetResponse" do
      it "adds tenant users to GetResponse" do
        expect_any_instance_of(User).to receive(:add_to_get_response)
        new_user = build(:user, address: " 123 Fake St ", first_name: "Kevin  ", last_name: "Tenant  ")
        post :create, params: { user: new_user.attributes.merge(password: 'password', password_confirmation: 'password') }
      end

      it "does not add non-tenant users to GetResponse" do
        expect_any_instance_of(User).to_not receive(:add_to_get_response)
        new_user = build(:user, address: " 123 Fake St ", first_name: "Kevin  ", last_name: "Tenant  ", permissions: 25)
        post :create, params: { user: new_user.attributes.merge(password: 'password', password_confirmation: 'password') }
      end
    end

    context "creates user and associates with a new building" do
      context "set_location_data param is missing or false" do
        it "associates the user with a new building but does not geolocate", :vcr do
          new_user = build(:user)
          post :create, params: { user: new_user.attributes.merge(
              password: 'password',
              password_confirmation: 'password'
          )}

          user = User.last
          expect(user.first_name).to eq(new_user.first_name)
          expect(user.last_name).to eq(new_user.last_name)
          expect(user.building.street_address).to eq(new_user.address)
          expect(user.building.zip_code).to eq(new_user.zip_code)
          expect(user.building.city).to eq(nil)
        end
      end

      context "set_location_data param is true" do
        it "associates the user with a new building but does not geolocate", :vcr do
          post :create, params: { user: {
            first_name: 'Jane',
            last_name: 'Doe',
            email: 'jane@heatseeknyc.com',
            password: 'password',
            password_confirmation: 'password',
            address: '40 Broad St',
            zip_code: '10004',
            set_location_data: 'true'
          }}

          user = User.last
          expect(user.first_name).to eq('Jane')
          expect(user.last_name).to eq('Doe')
          expect(user.building.street_address).to eq('40 Broad St')
          expect(user.building.zip_code).to eq('10004')
          expect(user.building.city).to eq('New York')
          expect(user.building.state).to eq('New York')
        end
      end
    end
  end
end
