require 'omniauth-oauth2'
require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class JoinMe < OmniAuth::Strategies::OAuth2

      option :name, 'joinme'
      option :scope, 'user_info'
      option :client_options, {
        :site => 'https://api.join.me/v1',
        :authorize_url => 'https://secure.join.me/api/public/v1/auth/oauth2'
      }

      uid{ raw_info['email'] }

      info do
        {
          :name => raw_info['fullName'],
          :email => raw_info['email']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('https://api.join.me/v1/user').parsed
      end

      def request_phase
        parse_callback_url = full_host + script_name + '/account/auth/joinme/parse_callback' + query_string
        # Using implicit strategy will set response_type = token
        redirect client.implicit.authorize_url({:redirect_uri => parse_callback_url}.merge(authorize_params))
      end

      protected

      def build_access_token
        ::OAuth2::AccessToken.from_hash(client, {:access_token => request.params['access_token']})
      end
    end
  end
end

OmniAuth.config.add_camelization 'joinme', 'JoinMe'
