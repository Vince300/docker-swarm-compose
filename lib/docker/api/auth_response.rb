require "docker/api/auth_response"

module Docker
  module Api
    class AuthResponse < Entity
      attr_accessor :status, :identity_token
    end
  end
end