class ApplicationController < ActionController::Metal
  include AbstractController::Rendering
  include ActionController::Rendering
  include ActionController::Renderers        # render json
  include AbstractController::Callbacks      # callbacks for your authentication logic
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  http_basic_authenticate_with name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD']

  use_renderers :json

  before_action -> { response.headers['Content-Type'] = 'application/json' }
end
