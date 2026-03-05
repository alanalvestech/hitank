# Restore a DNS snapshot
# Usage: ruby scripts/dns_restore.rb DOMAIN SNAPSHOT_ID

require_relative 'auth'

domain      = ARGV[0] or abort("Usage: ruby #{__FILE__} DOMAIN SNAPSHOT_ID")
snapshot_id = ARGV[1] or abort("Missing SNAPSHOT_ID")

hostinger_request(:post, "/api/dns/v1/snapshots/#{domain}/#{snapshot_id}/restore")

puts "DNS snapshot #{snapshot_id} restored for #{domain}"
