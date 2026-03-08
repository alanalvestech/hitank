# List projects for a Sentry organization
# Usage: ruby scripts/projects.rb ORG_SLUG

require_relative 'auth'

org = ARGV[0] or abort("Usage: ruby #{__FILE__} ORG_SLUG")

data = sentry_request(:get, "/organizations/#{org}/projects/")

data.each do |proj|
  slug     = proj['slug'] || '-'
  name     = proj['name'] || '-'
  platform = proj['platform'] || '-'
  status   = proj['status'] || '-'
  puts "#{slug}\t#{name}\t#{platform}\t#{status}"
end
