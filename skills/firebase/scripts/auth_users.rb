# List Firebase Auth users (contains PII — requires user confirmation)
# Usage: ruby scripts/auth_users.rb PROJECT_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

data = firebase_request(
  :get,
  "/v1/projects/#{project_id}/accounts:batchGet",
  base_url: 'https://identitytoolkit.googleapis.com'
)

if data.nil? || data['users'].nil? || data['users'].empty?
  puts "No auth users found."
  exit 0
end

data['users'].each do |user|
  uid      = user['localId'] || '-'
  email    = user['email'] || '-'
  display  = user['displayName'] || '-'
  provider = (user['providerUserInfo'] || []).map { |p| p['providerId'] }.join(', ')
  created  = user['createdAt'] || '-'
  last_login = user['lastLoginAt'] || '-'
  puts "#{uid}\t#{email}\t#{display}\tproviders=[#{provider}]\tcreated=#{created}\tlast_login=#{last_login}"
end
