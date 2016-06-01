require 'spec_helper'

describe ReadingsController do
  describe "GET /readings/index" do
    let(:exporter) { double("readings_exporter") }

    before do
      allow(exporter).to receive(:to_csv)
    end

    it "returns a 401 error for unauthorized users" do
      sign_in create(:advocate)
      get :index, format: :csv
      expect(response.status).to eq(401)
    end

    context "authorized user sign in" do
      before { sign_in create(:team_member) }

      it "sends data in csv format" do
        expect(controller)
          .to receive(:send_data)
          .with("#{ReadingsExporter::HEADERS.join(',')}\n",
                filename: "sensor_readings.csv",
                type: "text/csv; charset=utf-8; header=present")
          .and_return { controller.render nothing: true }
        get :index, format: :csv
      end

      it "instantiates a ReadingsExporter using the provided query parameters" do
        expect(ReadingsExporter)
          .to receive(:new)
          .with("filter" => { "user_id" => 1 })
          .and_return { exporter }
        get :index, format: :csv, readings: { filter: { user_id: 1 } }
      end
    end
  end
end
