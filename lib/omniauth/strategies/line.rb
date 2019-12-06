require 'omniauth-oauth2'
require 'json'

module OmniAuth
  module Strategies
    class Line < OmniAuth::Strategies::OAuth2
      option :name, 'line'
      option :scope, 'profile openid email'

      option :client_options, {
        site: 'https://access.line.me',
        authorize_url: '/oauth2/v2.1/authorize',
        token_url: '/oauth2/v2.1/token'
      }

      # host changed
      def callback_phase
        options[:client_options][:site] = 'https://api.line.me'
        super
      end

      uid { raw_info['sub'] }

      info do
        {
          name:        raw_info['name'],
          image:       raw_info['picture'],
          email:       raw_info['email']
        }
      end

      # Require: Access token with PROFILE permission issued.
      def raw_info
        @raw_info ||= get_raw_info
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end

      def callback_url
        options[:callback_url] || (full_host + script_name + callback_path)
      end

      private
        def get_raw_info
          # https://developers.line.biz/ja/reference/social-api/#verify-id-token
          res = access_token.post("oauth2/v2.1/verify", {body: {id_token: access_token.params["id_token"], client_id: options[:client_id]}})
          JSON.load(res.body)
        end
    end
  end
end
