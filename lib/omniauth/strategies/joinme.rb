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
        prune!(
        {
          :name => raw_info['full_name'],
          :email => raw_info['email'],
          :conference_settings => raw_info['conference_settings']
        })
      end

      extra do
        prune!({
          'raw_info' => raw_info
        })
      end

      def raw_info
        @raw_info ||= keys_to_underscore(access_token.get('user').parsed)
      end

      def request_phase
        # Using implicit strategy will set response_type = token
        redirect client.implicit.authorize_url({:redirect_uri => parse_callback_url}.merge(authorize_params))
      end

      def callback_phase
        if request.params['isAuthorizationRenewed'].present?
          # Our response doesn't contain any access token info so let's return
          # to our app's callback
          call_app!
        else
          super
        end
      end

      def parse_callback_url
        full_host + script_name + parse_callback_path + query_string
      end

      def parse_callback_path
        @parse_callback_path ||= begin
          path = options[:parse_callback_path] if options[:parse_callback_path].is_a?(String)
          path ||= current_path if options[:parse_callback_path].respond_to?(:call) && options[:parse_callback_path].call(env)
          path ||= custom_path(:request_path)
          path ||= "#{path_prefix}/#{name}/parse_callback"
          path
        end
      end

      protected

      def build_access_token
        ::OAuth2::AccessToken.from_hash(client, {:access_token => request.params['access_token']})
      end

      private

      def prune!(hash)
        hash.delete_if do |key, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty) && value.empty?)
        end
      end

      def keys_to_underscore(hash)
        new_hash = {}
        hash.each do |key, value|
          value = keys_to_underscore(value) if value.is_a?(Hash)
          new_key = key.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
                        gsub(/([a-z\d])([A-Z])/,'\1_\2').
                        tr('-', '_').
                        downcase
          new_hash[new_key] = value
        end
        new_hash
      end
    end
  end
end

OmniAuth.config.add_camelization 'joinme', 'JoinMe'
