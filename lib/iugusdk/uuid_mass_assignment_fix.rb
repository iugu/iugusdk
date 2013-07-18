module ActiveUUID
  module UUID
    def self.included(base)
      base.before_validation :fix_uuid_strings
    end

    def fix_uuid_strings
      self.class.columns_hash.each do |key, fk|
        next unless fk.type == :binary && fk.limit == 255 && /^.+_id$/.match(key.to_s)
        value = self.send fk.name
        if !value.blank? && value.class != UUIDTools::UUID
          self.send "#{fk.name}=", value.to_uuid
        end
      end
    end
  end
end
