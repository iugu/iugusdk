class UserInvitation < ActiveRecord::Base
  validates :email, :email => true, :presence => true
  before_save :set_token
  before_create :set_sent_at
  after_create :send_email

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

  def accept(user)
    Account.find(account_id).account_users << account_user = AccountUser.create(:user_id => user.id)
    account_user.set_roles(roles.split(',')) if roles
  end

  private

  def set_token
    self.token = SecureRandom.urlsafe_base64(20) unless token
  end

  def set_sent_at
    self.sent_at = Time.now
  end

  def send_email
    IuguMailer.invitation(self).deliver
  end
end

