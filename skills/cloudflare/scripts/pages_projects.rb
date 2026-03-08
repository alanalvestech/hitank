# List Pages projects for a Cloudflare account
# Usage: ruby scripts/pages_projects.rb ACCOUNT_ID

require_relative 'auth'

account_id = ARGV[0] or abort("Usage: ruby #{__FILE__} ACCOUNT_ID")

data = cf_request(:get, "/accounts/#{account_id}/pages/projects")

unless data['success']
  abort "Error: #{(data['errors'] || []).map { |e| e['message'] }.join(', ')}"
end

data['result'].each do |project|
  subdomain  = project['subdomain'] || '-'
  created    = project['created_on'] || '-'
  prod_branch = project.dig('production_branch') || '-'
  puts "#{project['name']}\t#{subdomain}\t#{prod_branch}\t#{created}"
end
