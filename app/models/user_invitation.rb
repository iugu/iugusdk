class UserInvitation < ActiveRecord::Base
  include ActiveUUID::UUID

  validates :email, :email => true, :presence => true
  validates :roles, presence: true
  validate :email_already_used?
  before_save :set_token
  before_create :set_sent_at
  after_create :send_email

  belongs_to :account

  attr_accessible :email, :roles, :account_id, :invited_by

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
    if account.account_users.where(:user_id => user.id).empty?
      account_user = account.account_users.create(:user => user)
      account_user.set_roles(roles.split(',')) if roles
      self.used = true
      save
      true
    else
      false
    end
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

  def email_already_used?
    if !AccountUser.joins(:user).where(:account_id => account_id, 'users.email' => email).empty?
      errors.add(:email, "already used in this account")
    end
  end
end

