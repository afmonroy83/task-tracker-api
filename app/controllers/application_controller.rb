class ApplicationController < ActionController::API
  before_action :authenticate_frontend!

  protected

  # Authentication
  def authenticate_frontend!
    token = request.headers["X-API-TOKEN"]

    unless valid_token?(token)
      render json: {
        status: 401,
        error: "Unauthorized"
      }, status: :unauthorized
    end
  end

  def valid_token?(token)
    expected = ENV["FRONTEND_API_TOKEN"].to_s
    return false if expected.empty?

    ActiveSupport::SecurityUtils.secure_compare(
      token.to_s,
      expected
    )
  end

  # Response helpers
  def render_success(data, status: :ok)
    render json: {
      status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status],
      data: data
    }, status: status
  end

  def render_error(errors, status:)
    render json: {
      status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status],
      errors: Array(errors)
    }, status: status
  end

  def render_unprocessable_content(exception)
    render_error(exception.record.errors.full_messages, :unprocessable_content)
  end
end
