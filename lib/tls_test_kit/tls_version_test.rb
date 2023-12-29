module TLSTestKit
  class TLSVersionTest < Inferno::Test
    title 'Server supports TLS'
    description %(
      Verify that a server supports TLS.
    )
    id :tls_version_test

    output :incorrectly_permitted_tls_versions_messages

    class << self
      def versions
        {
          OpenSSL::SSL::SSL2_VERSION => 'SSL 2.0',
          OpenSSL::SSL::SSL3_VERSION => 'SSL 3.0',
          OpenSSL::SSL::TLS1_VERSION => 'TLS 1.0',
          OpenSSL::SSL::TLS1_1_VERSION => 'TLS 1.1',
          OpenSSL::SSL::TLS1_2_VERSION => 'TLS 1.2',
          OpenSSL::SSL::TLS1_3_VERSION => 'TLS 1.3',
        }
      end

      def version_keys
        @version_keys ||= versions.keys
      end

      def minimum_allowed_version
        @minimum_allowed_version ||=
          config.options[:minimum_allowed_version].presence || version_keys.first
      end

      def maximum_allowed_version
        @maximum_allowed_version ||=
          config.options[:maximum_allowed_version].presence || version_keys.last
      end

      def allowed_versions
        @allowed_versions ||=
          version_keys.select do |version|
            minimum_allowed_index = version_keys.find_index(minimum_allowed_version) || 0
            maximum_allowed_index = version_keys.find_index(maximum_allowed_version) || version_keys.length - 1

            version_index = version_keys.find_index(version)
            version_index >= minimum_allowed_index && version_index <= maximum_allowed_index
        end
      end

      def required_versions
        @required_versions ||=
          config.options[:required_versions].presence || []
      end

      def version_allowed?(version)
        allowed_versions.include? version
      end

      def version_forbidden?(version)
        !version_allowed? version
      end

      def version_required?(version)
        required_versions.include? version
      end

      def incorrectly_permitted_tls_version_message_type
        config.options[:incorrectly_permitted_tls_version_message_type] || 'error'
      end
    end

    input :url

    run do
      skip_if url.blank?, "Could not verify when no url provided."
      uri = URI(url)
      host = uri.host
      port = uri.port
      tls_support_verified = false

      incorrectly_permitted_tls_versions = []

      self.class.versions.each do |version, version_string|
        http = Net::HTTP.new(host, port)
        http.use_ssl = true
        http.min_version = version
        http.max_version = version
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        begin
          http.request_get(uri)
          if self.class.version_forbidden? version
            message =
              "#{url} accepted #{version_string} connection even though #{version_string} connections should be denied. " \
              'The system may deny content from being sent over this connection, but this must be manually verified.'
            incorrectly_permitted_tls_versions << version_string

            add_message(self.class.incorrectly_permitted_tls_version_message_type, message)
          elsif self.class.version_required? version
            add_message('info', "#{url} correctly accepted #{version_string} connection as required.")
            tls_support_verified = true
          else
            add_message('info', "#{url} accepted #{version_string} connection.")
            tls_support_verified = true
          end
        rescue StandardError => e
          if self.class.version_required? version
            add_message('error', "#{url} incorrectly denied #{version_string} connection: #{e.message}")
          elsif self.class.version_forbidden? version
            add_message('info', "#{url} correctly denied #{version_string} connection as required.")
          else
            add_message('info', "#{url} denied #{version_string} connection.")
          end
        end
      end

      if incorrectly_permitted_tls_versions.present?
        count = incorrectly_permitted_tls_versions.length
        message =
          "#{url} did not deny TLS connections for #{'version'.pluralize(count)} " \
          "#{incorrectly_permitted_tls_versions.join(', ')}. The system may deny content from being sent over this " \
          'connection, but this must be manually verified.'
        output incorrectly_permitted_tls_versions_messages: message
      end

      errors_found = messages.any? { |message| message[:type] == 'error' }

      assert !errors_found, 'Server did not permit/deny the connections with the correct TLS versions'

      assert tls_support_verified, 'Server did not support any allowed TLS versions.'

      if incorrectly_permitted_tls_versions.present?
        pass "Server accepted TLS connections using versions which should be denied: #{incorrectly_permitted_tls_versions.join(', ')}"
      end
    end
  end
end
