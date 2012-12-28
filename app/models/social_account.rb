class SocialAccount < ActiveRecord::Base
  include ActiveUUID::UUID

  belongs_to :user

  def unlink
    if self.user.social_accounts.count == 1 && (self.user.email.blank? || self.user.encrypted_password.blank?)
      errors.add(:base, "only_social_and_no_email")
      false
    else
      self.destroy
    end
  end

end
