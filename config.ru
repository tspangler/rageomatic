require 'isangrytoday'
require 'logger'

run Sinatra::Application

# Logging
log = File.new("sinatra.log", "a+")
$stdout.reopen(log)
$stderr.reopen(log)