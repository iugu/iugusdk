class DestroyAccountUserJob < Struct.new(:id)
  def perform
    accountUser = AccountUser.find(id)
    accountUser._destroy if accountUser
  end
end
