# Toggle a feature flag on or off
# Usage: ruby scripts/toggle_flag.rb PROJECT_ID FLAG_ID true|false

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID FLAG_ID true|false")
flag_id    = ARGV[1] or abort("Missing FLAG_ID")
active_arg = ARGV[2] or abort("Missing active value (true or false)")

active = active_arg == 'true'

data = posthog_request(:patch, "/api/projects/#{project_id}/feature_flags/#{flag_id}/", body: { active: active })

status = data['active'] ? 'active' : 'inactive'
puts "Flag '#{data['key']}' is now #{status}"
