Fabricator(:user) do
  email "teste@teste.com"
  password "123456"
  confirmed_at Time.now
  locale "en"
end

Fabricator(:user_without_email, :class_name => :user) do
  password "123456"
  confirmed_at Time.now
end
