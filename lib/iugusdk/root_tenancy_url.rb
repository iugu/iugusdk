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
      valids.include?( request.host )
    end

  end
end
