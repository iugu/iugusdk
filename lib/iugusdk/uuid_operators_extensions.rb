class String
  def to_uuid
    UUIDTools::UUID.parse_hexdigest( self.gsub("-","").upcase )
  end
end
