# List Firebase Hosting sites for a project
# Usage: ruby scripts/hosting_sites.rb PROJECT_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

data = firebase_request(
  :get,
  "/v1beta1/projects/#{project_id}/sites",
  base_url: 'https://firebasehosting.googleapis.com'
)

if data.nil? || data['sites'].nil? || data['sites'].empty?
  puts "No hosting sites found."
  exit 0
end

data['sites'].each do |site|
  name       = site['name']&.split('/')&.last || '-'
  default_url = site['defaultUrl'] || '-'
  type       = site['type'] || '-'
  puts "#{name}\t#{default_url}\t#{type}"
end
