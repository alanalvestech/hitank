# List databases for an organization
# Usage: ruby scripts/databases.rb ORG

require_relative 'auth'

org = ARGV[0] or abort("Usage: ruby #{__FILE__} ORG")

data = ps_request(:get, "/organizations/#{org}/databases")

dbs = data['data'] || data
dbs = [dbs] unless dbs.is_a?(Array)

dbs.each do |db|
  region  = db['region'] || db.dig('region', 'slug') || '-'
  state   = db['state'] || '-'
  created = db['created_at'] || '-'
  puts "#{db['name']}\t#{region}\t#{state}\t#{created}"
end
