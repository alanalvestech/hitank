# List releases for a Sentry organization
# Usage: ruby scripts/releases.rb ORG_SLUG

require_relative 'auth'

org = ARGV[0] or abort("Usage: ruby #{__FILE__} ORG_SLUG")

data = sentry_request(:get, "/organizations/#{org}/releases/")

data.each do |release|
  version    = release['version'] || '-'
  short      = release['shortVersion'] || '-'
  status     = release['status'] || '-'
  created    = release['dateCreated'] || '-'
  new_groups = release['newGroups'] || '-'
  puts "#{version}\t#{short}\t#{status}\t#{new_groups}\t#{created}"
end
