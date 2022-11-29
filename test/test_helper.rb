$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "omniauth/strategies/joinme"

require "minitest/autorun"
require "mocha/minitest"

OmniAuth.config.test_mode = true
