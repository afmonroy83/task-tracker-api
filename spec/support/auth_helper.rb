module AuthHelper
  def auth_headers
    {
      "X-API-TOKEN" => ENV["FRONTEND_API_TOKEN"]
    }
  end
end
