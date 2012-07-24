Fabricator(:social_account) do
  user
  provider "twitter"
  social_id "123123123"
end

Fabricator(:social_account_without_user, :class_name => :social_account) do
  provider "twitter"
  social_id "123123123"
end
