# OmniAuth join.me Strategy

A join.me OAuth2 strategy for OmniAuth.

For more details, read [the join.me documentation](https://developer.join.me/docs).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "omniauth-joinme"
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install omniauth-joinme
```

## Usage

Register your application with join.me to receive an API key: [https://developer.join.me/member/register](https://developer.join.me/member/register)

This is an example that you might put into a Rails initializer at `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :joinme, ENV["JOINME_CLIENT_ID"], ENV["JOINME_SECRET"]
end
```

You can now access the OmniAuth join.me OAuth2 URL: `/auth/joinme`.


## Granting Additional Permissions to Your Application

With the join.me API, you have the ability to specify which permissions you want users to grant your application.
For more details, read [the join.me documentation](https://developer.join.me/docs).

By default, omniauth-joinme requests the following permissions:

```ruby
"user_info"
```

You can configure the scope option:

```ruby
provider :joinme, ENV["JOINME_CLIENT_ID"], ENV["JOINME_SECRET"], scope: "user_info start_meeting"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
