Fabricator(:account_domain) do
  account
  url "www.testing.net"
end

Fabricator(:account_domain_without_account, :class_name => :account_domain) do
  url "www.testing.net"
end
