class DestroyUserJob < Struct.new(:id)
  def perform
    user = User.find(id)
    user._destroy if user
  end
end
