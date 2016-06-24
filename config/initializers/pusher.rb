# config/initializers/pusher.rb
require 'pusher'

Pusher.app_id = '219639'
Pusher.key = ENV["PUSHER_KEY_BASE"]
Pusher.secret = ENV["PUSHER_SECRET_BASE"]
Pusher.cluster = 'ap1'
Pusher.logger = Rails.logger
Pusher.encrypted = true
