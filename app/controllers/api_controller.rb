class ApiController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |e|
    error(e.message, 404)
  end

  def success(data = {}, status = 200)
    render json: data, status: status
  end

  def error(data = {}, status = 400)
    render json: data, status: status
  end
end
