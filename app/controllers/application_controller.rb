class ApplicationController < ActionController::API
  include ControllerAuthenticatable
  include Response
end
