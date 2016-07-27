require 'omniauth-oauth2'
require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class JoinMe < OmniAuth::Strategies::OAuth2

      option :name, 'joinme'
      option :scope, 'user_info'
      option :client_options, {
        :site => 'https://api.join.me/v1',
        :authorize_url => 'https://secure.join.me/api/public/v1/auth/oauth2',
        :token_url => 'https://secure.join.me/api/public/v1/auth/token'
      }

      uid { raw_info['email'] }

      info do
        {
          :name => raw_info['full_name'],
          :email => raw_info['email'],
          :conference_settings => raw_info['conference_settings']
        }
      end

      extra do
        { 'raw_info' => raw_info }
      end

      def raw_info
        @raw_info ||= MultiJson.decode(access_token.get('user').body)
      end

      # Exclude query string in callback_url to prevent redirect_uri mismatch
      def callback_url
        options[:callback_url] || (full_host + script_name + callback_path)
      end

    end
  end
end

OmniAuth.config.add_camelization 'joinme', 'JoinMe'
