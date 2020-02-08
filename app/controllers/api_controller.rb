class ApiController < ActionController::API
  def success(data = {}, status = 200)
    render json: data, status: status
  end

  def error(data = {})
    render json: data, status: 400
  end
end
