require_relative 'tls_version_test'

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

    links [
      {
        type: 'report_issue',
        label: 'Report Issue',
        url: 'https://github.com/inferno-framework/tls-test-kit/issues/'
      },
      {
        type: 'source_code',
        label: 'Open Source',
        url: 'https://github.com/inferno-framework/tls-test-kit/'
      },
      {
        type: 'download',
        label: 'Download', 
        url: 'https://github.com/inferno-framework/tls-test-kit/releases/'
      }
    ]
  end
end
