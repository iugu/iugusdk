Fabricator(:user) do
  email "teste@teste.com"
  password "123456"
  confirmed_at Time.now
end
