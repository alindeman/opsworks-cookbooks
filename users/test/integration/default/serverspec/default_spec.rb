require 'spec_helper'

describe user('alindeman') do
  it { is_expected.to exist }
  it { is_expected.to have_login_shell('/bin/false') }
end
