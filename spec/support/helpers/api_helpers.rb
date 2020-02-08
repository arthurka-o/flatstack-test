module ApiHelpers
  def json_response_body
    JSON.parse(response_body, symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include ApiHelpers
end
