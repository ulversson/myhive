require 'jwt'
require_relative './jwt_helper.rb'
payload = ARGV[0]
token = JwtHelper.decode(payload)
puts token