class String
  def to_uuid
    return UUIDTools::UUID.parse_raw self if self.size == 16
    UUIDTools::UUID.parse_hexdigest( self.gsub("-","").upcase )
  end
end
