# List all DigitalOcean droplets
# Usage: ruby scripts/droplets.rb

require_relative 'auth'

data = do_request(:get, '/droplets')

data['droplets'].each do |d|
  name   = d['name'] || '-'
  id     = d['id']
  status = d['status'] || '-'
  region = d.dig('region', 'slug') || '-'
  size   = d.dig('size', 'slug') || d['size_slug'] || '-'
  ip     = (d.dig('networks', 'v4') || []).find { |n| n['type'] == 'public' }&.dig('ip_address') || '-'
  puts "#{id}\t#{name}\t#{status}\t#{region}\t#{size}\t#{ip}"
end
