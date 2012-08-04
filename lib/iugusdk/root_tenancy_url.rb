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
      valids = [ application_domain, ['www.',application_domain].join ]
      unless Rails.env.production?
        first_part_uri = application_domain.gsub('.dev','')
        return true if request.host.match("#{first_part_uri}\.[^\.]+\.[^\.]+\.[^\.]+\.[^\.]+\.xip.io")
      end
      valids.include?( request.host )
    end

  end
end
