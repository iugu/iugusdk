class SocialAccount < ActiveRecord::Base
  before_destroy do
    if self.user.social_accounts.count == 1 && (self.user.email.blank? || self.user.encrypted_password.blank?)
      errors.add(:base, "only_social_and_no_email")
      false
    else
      true
    end
  end

  belongs_to :user
end
