class ApiToken < ActiveRecord::Base
  belongs_to :tokenable, :polymorphic => true

  before_create :set_first_token

  validates :token, :uniqueness => true
  validates :description, :uniqueness => { :scope => [:tokenable_id, :tokenable_type] }
  validates :description, :tokenable, :api_type, :presence => true
  validate :valid_api_type


  private

  def set_first_token
    self.token = generate_api_token
  end 

  def generate_api_token
    Digest::MD5.hexdigest("#{SecureRandom.hex(10)}-#{DateTime.now.to_s}")
  end 

  def valid_api_type
    errors.add(:api_type, I18n.t('errors.messages.not_supported_api_type')) unless IuguSDK::account_api_tokens.include? api_type
  end

  
end
