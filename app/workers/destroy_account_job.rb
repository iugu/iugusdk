class DestroyAccountJob < Struct.new(:id)
  def perform
    account = Account.find(id)
    account._destroy if account
  end
end
