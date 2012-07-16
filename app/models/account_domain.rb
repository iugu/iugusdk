require 'resolv'
require 'uri'
class AccountDomain < ActiveRecord::Base
  belongs_to :account
  validates :url, :uniqueness => true
  validates :url, :account_id, :presence => true
  validate :validate_pattern

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
    update_attribute(:verified, checked)
    checked
  end

  def set_primary
    AccountDomain.where(:account_id => account_id).update_all(:primary => false)
    update_attribute(:primary, true)
  end

  private

  def validate_pattern
    if url
      errors.add(:url, "Invalid Pattern") unless url.match /^([a-z0-9]*\.)*[a-z0-9]*$/
    end
  end
  
  
end
