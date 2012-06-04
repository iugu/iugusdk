# ValidTenancyUrls will lookup configuration hash and
# deal with invalid urls. Its used by routing to constrain
# multi tenancy controllers
# SAAS: File related to SAAS with Custom Domains functionality

# TODO: Write Tests (PN)
module IuguSDK
  class ValidTenancyUrls

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
      invalids = [ application_domain, ['www.',application_domain].join ]
      invalids |= IuguSDK::custom_domain_invalid_prefixes.map { |prefix| [prefix,application_domain].join }
      invalids |= IuguSDK::custom_domain_invalid_hosts
      !invalids.include?( request.host )
    end

  end
end
