$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'omniauth/strategies/joinme'

require 'minitest/autorun'
require 'mocha/setup'

OmniAuth.config.test_mode = true
