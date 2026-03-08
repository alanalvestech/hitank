# List backups for a PlanetScale database
# Usage: ruby scripts/backups.rb ORG DATABASE

require_relative 'auth'

org = ARGV[0] or abort("Usage: ruby #{__FILE__} ORG DATABASE")
db  = ARGV[1] or abort("Usage: ruby #{__FILE__} ORG DATABASE")

data = ps_request(:get, "/organizations/#{org}/databases/#{db}/backups")

backups = data['data'] || data
backups = [backups] unless backups.is_a?(Array)

backups.each do |b|
  id        = b['id'] || '-'
  state     = b['state'] || '-'
  size      = b['size'] || '-'
  branch    = b['branch'] || b.dig('branch', 'name') || '-'
  created   = b['created_at'] || '-'
  puts "#{id}\t#{branch}\t#{state}\t#{size}\t#{created}"
end
