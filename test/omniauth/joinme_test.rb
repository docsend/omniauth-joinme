require "test_helper"

class JoinmeTest < Minitest::Test
  def setup
    @request = stub("Request")
    @request.stubs(:params).returns({})
    @request.stubs(:cookies).returns({})
    @request.stubs(:env).returns({})
    @request.stubs(:scheme).returns({})
    @request.stubs(:ssl?).returns(false)

    @client_id = "12345"
    @client_secret = "secret"
  end

  def test_returns_the_default_callback_url_without_query_string
    url_base = "http://auth.request.com"
    @request.stubs(:url).returns("#{url_base}/some/page")
    strategy.stubs(:script_name).returns("") # as not to depend on Rack env
    strategy.stubs(:query_string).returns("?foo=bar")
    assert_equal "#{url_base}/auth/joinme/callback", strategy.callback_url
  end

  def test_returns_the_default_callback_path_without_query_string
    @options = {callback_path: "/auth/joinme/done"}
    url_base = "http://auth.request.com"
    @request.stubs(:url).returns("#{url_base}/page/path")
    strategy.stubs(:script_name).returns("") # as not to depend on Rack env
    strategy.stubs(:query_string).returns("?foo=bar")
    assert_equal "#{url_base}/auth/joinme/done", strategy.callback_url
  end

  def test_returns_url_from_callback_url_option
    url = "https://auth.myapp.com/auth/joinme/callback"
    @options = {callback_url: url}
    assert_equal url, strategy.callback_url
  end

  def test_returns_refresh_token
    assert_equal strategy.credentials["refresh_token"], strategy.access_token.refresh_token
  end

  private

  def strategy
    @strategy ||= begin
      args = [@client_id, @client_secret, @options].compact
      OmniAuth::Strategies::Joinme.new(nil, *args).tap do |strategy|
        strategy.stubs(:request).returns(@request)
        strategy.stubs(:access_token).returns(access_token)
      end
    end
  end

  def access_token
    @client ||= OAuth2::Client.new "id", "secret", {site: "example.com"}
    @access_token ||= OAuth2::AccessToken.from_hash @client, {
      "access_token" => "token",
      "refresh_token" => "refresh_token"
    }
  end
end
