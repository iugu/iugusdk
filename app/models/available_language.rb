# encoding: utf-8
#
class AvailableLanguage
  def self.all
    begin
      YAML.load_file("#{Rails.root.to_s}/config/available_language.yml")['locales']
    rescue
      {"English" => "en", 'Português (Brasil)' => "pt-BR"}
    end
  end
  
end
