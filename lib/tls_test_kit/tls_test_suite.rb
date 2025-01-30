require_relative 'tls_test_version'

module TLSTestKit
  class TLSTestSuite < Inferno::TestSuite
    title 'TLS Tests'
    id :tls

    group do
      title 'TLS Tests'

      test from: :tls_version_test,
           title: 'Server only supports secure versions of TLS',
           description: %(
             This test verifies that a server supports at least one version of
             TLS >= 1.2. TLS versions below 1.2 were [deprecated in RFC
             8666](https://datatracker.ietf.org/doc/html/rfc8996).
           ),
           config: {
             options: {
               minimum_allowed_version: OpenSSL::SSL::TLS1_2_VERSION
             }
           }
    end
  end
end
