# metadata.rb

require_relative 'version'

module TLSTestKit
  # Although the TLS Test Kit is not hosted on the deployment platform,
  # let's have it conform to the platform_deployable_test_kit spec anyways
  # since its a dependency.
  class Metadata < Inferno::TestKit
    id :tls_test_kit
    title 'TLS Test Kit'
    suite_ids ['tls']
    tags []
    last_updated TLSTestKit::LAST_UPDATED
    version TLSTestKit::VERSION
    maturity 'Medium'
    authors ['Stephen MacVicar']
    repo 'https://github.com/inferno-framework/tls-test-kit'
    description <<~DESCRIPTION
      This is an [Inferno](https://inferno-framework.github.io/) Test Kit for 
      TLS connections.
      <!-- break -->
      ## Repository

      The TLS Test Kit GitHub repository can be
      [found here](https://github.com/inferno-framework/tls-test-kit).

      ## Providing Feedback and Reporting Issues

      We welcome feedback on the Test Kit. Please report any issues with this 
      set of tests in the 
      [issues section](https://github.com/inferno-framework/tls-test-kit/issues)
      of the repository.
    DESCRIPTION
  end
end
