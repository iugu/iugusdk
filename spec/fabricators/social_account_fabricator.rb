Fabricator(:social_account) do
  user!
  provider "twitter"
  social_id "123123123"
end
