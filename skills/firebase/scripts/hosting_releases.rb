# List Firebase Hosting releases for a site
# Usage: ruby scripts/hosting_releases.rb PROJECT_ID SITE_NAME

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID SITE_NAME")
site_name  = ARGV[1] or abort("Usage: ruby #{__FILE__} PROJECT_ID SITE_NAME")

data = firebase_request(
  :get,
  "/v1beta1/sites/#{site_name}/releases",
  base_url: 'https://firebasehosting.googleapis.com'
)

if data.nil? || data['releases'].nil? || data['releases'].empty?
  puts "No releases found for site '#{site_name}'."
  exit 0
end

data['releases'].each do |release|
  name     = release['name']&.split('/')&.last || '-'
  type     = release['type'] || '-'
  status   = release.dig('version', 'status') || '-'
  created  = release.dig('version', 'createTime') || '-'
  message  = release['message'] || '-'
  puts "#{name}\t#{type}\tstatus=#{status}\tcreated=#{created}\tmessage=#{message}"
end
