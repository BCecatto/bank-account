# frozen_string_literal: true

module Api
    module V1
      class UsersController < Api::V1::ApplicationController
        before_action :authorize_request!
  
        def balance
          
        end
  
        private
  
        def user_params
          params.permit(
            :name, :username, :email, :password, :password_confirmation,
            :source_account_id, :destination_account_id, :amount
          )
        end
      end
    end
  end
  