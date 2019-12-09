# OmniAuth Line

This gem contains the Line OAuth2 Strategy for OmniAuth.

Supports the OpenID Connect Web Login. Read the Line developers docs for more details: https://developers.line.biz/en/docs/line-login/web/integrate-line-login/

## Using This Strategy

First start by adding this gem to your Gemfile:

```ruby
gem 'omniauth-line'
```

Next, tell OmniAuth about this provider. For a Rails app, your `config/initializers/omniauth.rb` file should look like this:

```ruby
# PROFILE permission required!!
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :line, "Channel_ID", "Channel_Secret"
end
```

Then, you need to apply for email permission.
https://developers.line.biz/en/docs/line-login/web/integrate-line-login/

If you do not need email, then remove email from scope.
(By default, email is in scope in this version.)
```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :line, "Channel_ID", "Channel_Secret", scope: 'profile openid'
end
```

## Authentication Hash
An example auth hash available in `request.env['omniauth.auth']`:

```ruby
{
  :provider => "line",
  :uid => "a123b4....",
  :info => {
    :name => "yamada tarou",
    :image => "http://dl.profile.line.naver.jp/xxxxx",
    :email => "email@xxx.com",
  },
  :credentials => {
    :token => "a1b2c3d4...", # The OAuth 2.0 access token
    :refresh_token => "a1b2c3d4...",
    :expires_at => 1578442...,
    :expires => true
  },
  :extra => {
  }
}
```

## Supported Rubies

OmniAuth Line is tested under 2.6.x.
