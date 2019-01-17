module V1
  class UsersController < ApplicationController
    skip_before_action :authorize_request, only: :create

    def create
      user = User.create!(user_params)
      auth_token = AuthenticateUser.new(user.email, user.password).call
      response = { message: Message.account_created, token: auth_token }
      json_response(response,:created)
    end

    def profile
      json_response(current_user)
    end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end
  end
end
