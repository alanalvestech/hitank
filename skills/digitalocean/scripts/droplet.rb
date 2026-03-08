# Get details for a DigitalOcean droplet
# Usage: ruby scripts/droplet.rb DROPLET_ID

require_relative 'auth'

droplet_id = ARGV[0] or abort("Usage: ruby #{__FILE__} DROPLET_ID")

data = do_request(:get, "/droplets/#{droplet_id}")
d = data['droplet']

public_ip  = (d.dig('networks', 'v4') || []).find { |n| n['type'] == 'public' }&.dig('ip_address') || '-'
private_ip = (d.dig('networks', 'v4') || []).find { |n| n['type'] == 'private' }&.dig('ip_address') || '-'

puts "id:\t#{d['id']}"
puts "name:\t#{d['name']}"
puts "status:\t#{d['status']}"
puts "region:\t#{d.dig('region', 'slug') || '-'}"
puts "size:\t#{d.dig('size', 'slug') || d['size_slug'] || '-'}"
puts "image:\t#{d.dig('image', 'slug') || d.dig('image', 'name') || '-'}"
puts "vcpus:\t#{d['vcpus']}"
puts "memory:\t#{d['memory']} MB"
puts "disk:\t#{d['disk']} GB"
puts "public_ip:\t#{public_ip}"
puts "private_ip:\t#{private_ip}"
puts "created_at:\t#{d['created_at'] || '-'}"
puts "tags:\t#{(d['tags'] || []).join(', ')}"
