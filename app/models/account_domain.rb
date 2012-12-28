require 'resolv'
require 'uri'
class AccountDomain < ActiveRecord::Base
  include ActiveUUID::UUID

  belongs_to :account
  validates :url, :account_id, :presence => true
  validate :validate_pattern, :validate_blacklist

  attr_accessible :url

  before_create :validate_not_repeated

  before_destroy do |record|
    record.verified = false
    record.primary = false
    record.save
  end
  before_destroy :set_first_domain

  scope :verified, where(:verified => true)

  def normalize_host
    begin
      normalized_url = url
      normalized_url = normalized_url.gsub('www.','')
      normalized_url = normalized_url.gsub('http://','')
      normalized_url = normalized_url.gsub('https://','')
      normalized_url = 'http://' + normalized_url
      URI.parse(normalized_url).host
    rescue
      nil
    end
  end

  def calculate_token
    url = normalize_host
    Digest::SHA1.hexdigest( "#{id}#{url}" )[8..24]
  end

  def verify
    url = normalize_host
    ref_id = self.calculate_token
    checked=false
    begin
      Socket.gethostbyname( "#{ref_id}.#{url}" )
      checked=true
    rescue SocketError
    end
    begin
      response = Net::HTTP.start(url, 80) {|http| http.head("/#{ref_id}.html") }
      checked = true if response.code == "200"
    rescue
    end
    AccountDomain.where(:url => self.url).update_all(:verified => false) if checked == true
    update_attribute(:verified, checked)
    set_first_domain
    checked
  end

  def set_primary
    if verified == true
      AccountDomain.where(:account_id => account_id).update_all(:primary => false)
      update_attribute(:primary, true)
    end
  end

  private

  def validate_pattern
    if url
      errors.add(:url, "Invalid Pattern") unless url.match /^([a-z0-9]*\.)*[a-z0-9]*$/
    end
  end

  def validate_blacklist
    if url
      IuguSDK::custom_domain_invalid_hosts.each do |invalid_host|
        errors.add(:url, "Domain on Blacklist") if url == invalid_host
      end
    end
  end

  def validate_not_repeated
    if url
      if !AccountDomain.where(:account_id => account_id, :url => url).empty?
        errors.add(:url, "already used for this account") 
        false
      end
    end
  end

  def set_first_domain
    if AccountDomain.where(:account_id => account_id, :primary => true).empty?
      AccountDomain.where(:account_id => account_id, :verified => true).first.try(:update_attribute, :primary, true)
    end
  end
  
  
end
