require 'spec_helper'

describe port(25) do
  it { is_expected.to be_listening.with('tcp') }
end

describe port(587) do
  it { is_expected.to be_listening.with('tcp') }
end
