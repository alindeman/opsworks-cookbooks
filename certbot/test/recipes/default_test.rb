# # encoding: utf-8

# Inspec test for recipe certbot::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe file('/usr/local/bin/certbot-auto') do
  it { is_expected.to be_executable }
end
