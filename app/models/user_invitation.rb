class UserInvitation < ActiveRecord::Base
  validates :email, :email => true, :presence => true
  before_save :set_token

  private

  def set_token
    self.token = SecureRandom.urlsafe_base64(20) unless token
  end
end

