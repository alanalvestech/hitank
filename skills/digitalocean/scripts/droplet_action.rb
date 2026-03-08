# Perform an action on a DigitalOcean droplet
# Usage: ruby scripts/droplet_action.rb DROPLET_ID ACTION [--name SNAPSHOT_NAME]
# Actions: reboot, power_off, power_on, shutdown, enable_backups, disable_backups,
#          enable_ipv6, password_reset, snapshot

require_relative 'auth'

droplet_id = ARGV[0] or abort("Usage: ruby #{__FILE__} DROPLET_ID ACTION [--name SNAPSHOT_NAME]")
action     = ARGV[1] or abort("Usage: ruby #{__FILE__} DROPLET_ID ACTION [--name SNAPSHOT_NAME]")

body = { type: action }

# For snapshot action, allow an optional --name argument
if action == 'snapshot'
  name_idx = ARGV.index('--name')
  if name_idx && ARGV[name_idx + 1]
    body[:name] = ARGV[name_idx + 1]
  end
end

data = do_request(:post, "/droplets/#{droplet_id}/actions", body: body)
a = data['action']

puts "id:\t#{a['id']}"
puts "type:\t#{a['type']}"
puts "status:\t#{a['status']}"
puts "started_at:\t#{a['started_at'] || '-'}"
puts "resource_id:\t#{a['resource_id']}"
