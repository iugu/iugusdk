Fabricator(:api_token) do
  description 'api token'
  api_type 'test'
  tokenable { Fabricate(:account) }
end
