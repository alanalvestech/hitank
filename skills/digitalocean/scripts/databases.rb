# List DigitalOcean managed databases
# Usage: ruby scripts/databases.rb

require_relative 'auth'

data = do_request(:get, '/databases')

data['databases'].each do |db|
  id     = db['id'] || '-'
  name   = db['name'] || '-'
  engine = db['engine'] || '-'
  status = db['status'] || '-'
  region = db['region'] || '-'
  size   = db['size'] || '-'
  puts "#{id}\t#{name}\t#{engine}\t#{status}\t#{region}\t#{size}"
end
