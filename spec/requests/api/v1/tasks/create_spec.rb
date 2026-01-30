require "rails_helper"

RSpec.describe "POST /api/v1/tasks", type: :request do
  let(:valid_params) do
    {
      task: {
        description: "New task"
      }
    }
  end

  context "with valid authentication" do
    it "creates a task" do
      expect {
        post "/api/v1/tasks", params: valid_params, headers: auth_headers
      }.to change(Task, :count).by(1)

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)

      expect(json["status"]).to eq(201)
      expect(json["data"]["description"]).to eq("New task")
    end

    it "returns errors when invalid" do
      post "/api/v1/tasks",
           params: { task: { description: "" } },
           headers: auth_headers

      expect(response).to have_http_status(:unprocessable_content)

      json = JSON.parse(response.body)

      expect(json["status"]).to eq(422)
      expect(json["errors"]).to include("Description can't be blank")
    end
  end

  context "without authentication" do
    it "returns 401" do
      post "/api/v1/tasks", params: valid_params

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
