class UserInvitation < ActiveRecord::Base
  validates :email, :email => true, :presence => true
  before_save :set_token

  def self.find_by_invitation_token(invitation_token)
    begin
      user_invitation = UserInvitation.find(id = invitation_token.gsub(/.{27}$/, ''))
      if user_invitation.token == invitation_token.gsub(/^#{id}/, '')
        return user_invitation
      else
        return nil
      end
    rescue
      return nil
    end
  end

  private

  def set_token
    self.token = SecureRandom.urlsafe_base64(20) unless token
  end
end

