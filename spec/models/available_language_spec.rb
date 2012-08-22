require 'spec_helper'

describe AvailableLanguage do
  context "best_locale_for" do
    it 'should return lang receive if suported' do
      AvailableLanguage.best_locale_for("en").should == "en"
    end
  
    it 'should return similar locale if lang received is not supported' do
      AvailableLanguage.best_locale_for("pt").should == "pt-BR"
    end

    it 'should return default locale if lang has no similar locale supported' do
      AvailableLanguage.best_locale_for("ch").should == "en"
    end

    it 'should accept pt_BR pattern' do
      AvailableLanguage.best_locale_for("pt_BR").should == "pt-BR"
    end

    it 'should accept pt-BR pattern' do
      AvailableLanguage.best_locale_for("pt-BR").should == "pt-BR"
    end
  
  end
end
