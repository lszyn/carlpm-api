class ApplicationController < ActionController::API
  # include Response
  include ExceptionHandler

  before_action :authorize_request
  attr_reader :current_user

  private

  # Check for valid request token and return user
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end

  def json_response(object, status = :ok)
    render json: object, status: status
  end

  # def json_object(object)
  #   defined? serializer ? serialize(object) : object
  # end
  #
  # def serialize(object)
  #   serializer.new(object)
  # end
end
