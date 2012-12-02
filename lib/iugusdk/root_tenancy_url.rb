# RootTenancyUrl will lookup configuration hash and

# TODO: Write Tests (PN)
module IuguSDK
  class RootTenancyUrl

    # +matches?+ will check a request.host against a set of invalid urls
    #
    # * *Args*:
    #   - +request+ -> An ActionDispatch::Request object
    # * *Success*
    #   - Return true if request.host is found in the invalid array
    # * *False*
    #   - Return true if request.host is not found in the invalid array
    def self.matches?(request)
      application_domain = IuguSDK::application_main_host
      application_domain = application_domain.gsub('.dev','')
      valids = [ application_domain, ['www.',application_domain].join, 'localhost' ]
      normalized_host = request.host.gsub('.dev','')
      unless Rails.env.production?
        return true if normalized_host.match("#{application_domain}\.[^\.]+\.[^\.]+\.[^\.]+\.[^\.]+\.xip.io")
      end
      valids.include?( normalized_host )
    end

  end
end
