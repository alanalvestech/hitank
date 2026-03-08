# List DigitalOcean block storage volumes
# Usage: ruby scripts/volumes.rb

require_relative 'auth'

data = do_request(:get, '/volumes')

data['volumes'].each do |v|
  id     = v['id'] || '-'
  name   = v['name'] || '-'
  region = v.dig('region', 'slug') || '-'
  size   = v['size_gigabytes'] || '-'
  droplet_ids = (v['droplet_ids'] || []).join(',')
  droplet_ids = '-' if droplet_ids.empty?
  created = v['created_at'] || '-'
  puts "#{id}\t#{name}\t#{region}\t#{size}GB\t#{droplet_ids}\t#{created}"
end
