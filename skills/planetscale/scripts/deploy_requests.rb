# List deploy requests for a PlanetScale database
# Usage: ruby scripts/deploy_requests.rb ORG DATABASE

require_relative 'auth'

org = ARGV[0] or abort("Usage: ruby #{__FILE__} ORG DATABASE")
db  = ARGV[1] or abort("Usage: ruby #{__FILE__} ORG DATABASE")

data = ps_request(:get, "/organizations/#{org}/databases/#{db}/deploy-requests")

requests = data['data'] || data
requests = [requests] unless requests.is_a?(Array)

requests.each do |dr|
  branch    = dr['branch'] || '-'
  state     = dr['state'] || dr['deployment_state'] || '-'
  number    = dr['number'] || dr['id'] || '-'
  created   = dr['created_at'] || '-'
  deploy_to = dr['into_branch'] || '-'
  puts "##{number}\t#{branch} -> #{deploy_to}\t#{state}\t#{created}"
end
