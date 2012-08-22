# encoding: utf-8
#
class AvailableLanguage
  def self.all
    default = {"English" => "en", 'Português (Brasil)' => "pt-BR"}
    begin
      YAML.load_file("#{Rails.root.to_s}/config/available_language.yml")['locales'] || default
    rescue
      default
    end
  end

  def self.best_locale_for(lang)
    lang.gsub!('_', '-')
    locale = "en"
    if self.all.values.include? lang
      locale = lang 
    else
      self.all.values.each do |l|
        locale = l if l.gsub(/-.*/, '') == lang.gsub(/-.*/, '')
      end
    end
    locale
  end

  def self.default_locale
    default = "en"
    begin
      YAML.load_file("#{Rails.root.to_s}/config/available_language.yml")['default'] || default
    rescue
      default
    end
  end
  
end
