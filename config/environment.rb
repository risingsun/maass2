# Load the rails application
require File.expand_path('../application', __FILE__)
require "openid/fetchers"
OpenID.fetcher.ca_file = '/usr/lib/ssl/certs/ca-certificates.crt'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
Maass2::Application.initialize!

