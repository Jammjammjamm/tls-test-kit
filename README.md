# TLS Test Kit

This is an [Inferno](https://github.com/inferno-community/inferno-core) test kit
for TLS connections.

## Instructions

- `./setup.sh`
- `./run.sh`

## How the test works

The `tls_version_test` allows you to check which versions of TLS are supported
on a server. You can configure minimum/maximum allowed values and specify
required versions. The test attempts to make a TLS connection using each of the
following versions, and will fail if a connection can't be made with a required
version, or if a connection can be made with a forbidden version:

- SSL 2.0
- SSL 3.0
- TLS 1.0
- TLS 1.1
- TLS 1.2
- TLS 1.3

## Using the TLS test in other test suites

The ruby `OpenSSL` library provides
[constants for each TLS version](https://ruby-doc.org/stdlib-2.7.3/libdoc/openssl/rdoc/OpenSSL/SSL.html):
```
OpenSSL::SSL::SSL2_VERSION
OpenSSL::SSL::SSL3_VERSION
OpenSSL::SSL::TLS1_VERSION
OpenSSL::SSL::TLS1_1_VERSION
OpenSSL::SSL::TLS1_2_VERSION
OpenSSL::SSL::TLS1_3_VERSION
```

Using these constants, you can configure the permitted/forbidden/required
versions. In the example below, only TLS 1.1 and 1.2 are permitted, and TLS 1.2
is required. All other versions are forbidden. No minimum/maximum allowed
version is enforced if none are specified.

The `incorrectly_permitted_tls_version_message_type` option allows you to
determine the behavior of the test when a server allows a TLS connection to be
established using an unpermitted version. It defaults to `'error'`, which will
cause the test to fail when a connection is established using an unpermitted
version. Values of `'info'` or `'warning'` will allow the test to still pass
with details in an info or warning message.

```ruby
require 'tls_test_kit'

test from: :tls_version_test do
  config(
    inputs: {
      url: {
        title: 'URL whose TLS connections will be tested'
      }
    },
    options: {
      minimum_allowed_version: OpenSSL::SSL::TLS1_1_VERSION,
      maximum_allowed_version: OpenSSL::SSL::TLS1_2_VERSION,
      required_versions: [OpenSSL::SSL::TLS1_2_VERSION],
      incorrectly_permitted_tls_version_message_type: 'warning'
    }
  )
end
```

## License

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at
```
http://www.apache.org/licenses/LICENSE-2.0
```
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
