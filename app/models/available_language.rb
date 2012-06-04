class AvailableLanguage
  def self.all
    begin
      YAML.load_file("#{Rails.root.to_s}/config/available_language.yml")['locales']
    rescue
      ["en"]
    end
  end
  
end
