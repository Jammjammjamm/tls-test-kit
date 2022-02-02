require_relative './tls_test_kit/tls_version_test'

module TLSTestKit
  class TLSTestSuite < Inferno::TestSuite
    title 'TLS Tests'

    group do
      title 'TLS Tests'

      test from: :tls_version_test
    end
  end
end
