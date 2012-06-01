Fabricator(:user) do
  email "teste@teste.teste"
  password "123456"
  confirmed_at Time.now
end
