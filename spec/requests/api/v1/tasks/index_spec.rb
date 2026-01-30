require "rails_helper"

RSpec.describe "GET /api/v1/tasks", type: :request do
  let!(:tasks) { create_list(:task, 3) }

  context "with valid authentication" do
    it "returns all tasks ordered by creation date" do
      get "/api/v1/tasks", headers: auth_headers

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["status"]).to eq(200)
      expect(json["data"].length).to eq(3)
    end
  end

  context "without authentication" do
    it "returns 401" do
      get "/api/v1/tasks"

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
