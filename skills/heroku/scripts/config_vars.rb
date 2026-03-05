# List config vars for a Heroku app
# Usage: ruby scripts/config_vars.rb APP [--reveal]

require_relative 'auth'

app = ARGV[0] or abort("Usage: ruby #{__FILE__} APP [--reveal]")
reveal = ARGV.include?('--reveal')

data = heroku_request(:get, "/apps/#{app}/config-vars")

data.each do |key, value|
  if reveal
    puts "#{key}=#{value}"
  else
    puts "#{key}=****"
  end
end
