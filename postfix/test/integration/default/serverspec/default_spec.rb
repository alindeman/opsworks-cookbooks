require 'spec_helper'

describe port(25) do
  it { is_expected.to be_listening.with('tcp') }
end

describe port(587) do
  it { is_expected.to be_listening.with('tcp') }
end

describe user("postfix") do
  it { is_expected.to belong_to_group("sasl") }
end

describe service("saslauthd") do
  it { is_expected.to be_running }
end
