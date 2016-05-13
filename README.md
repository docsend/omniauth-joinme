# OmniAuth join.me Strategy

A join.me OAuth2 strategy for OmniAuth

For more details, read the join.me documentation: [https://developer.join.me/docs](https://developer.join.me/docs)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-joinme'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-joinme

## Usage

Register your application with join.me to receive an API key: [https://developer.join.me/member/register](https://developer.join.me/member/register)

This is an example that you might put into a Rails initializer at `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :joinme, ENV['JOINME_CLIENT_ID']
end
```

You can now access the OmniAuth join.me OAuth2 URL: `/auth/joinme`.

## Setup Additional Parse Callback Route

Because the join.me API is currently only supporting the OAuth 2.0 implicit grant scenario, an additional route is required to parse join.me's response.

Create an additional route for `/auth/joinme/parse_callback` and render an html page that uses JavaScript to parse the response and return the parameters to the server.
For example:

```javascript
  var queryString = location.hash.substring(1);
  var request = new XMLHttpRequest();
  request.open('POST', '/account/auth/joinme/callback', true);
  request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
  request.onreadystatechange = function(e) {
    if (request.readyState == 4) {
      if (request.status == 200) {
        window.location = some_new_location;
      }
    }
  }
  request.send(queryString);
```

## Granting Additional Permissions to Your Application

With the join.me API, you have the ability to specify which permissions you want users to grant your application.
For more details, read the join.me documentation: https://developer.join.me/docs

By default, omniauth-joinme requests the following permissions:

    'user_info'

You can configure the scope option:

```ruby
provider :joinme, ENV['JOINME_CLIENT_ID'], :scope => 'user_info start_meeting'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

