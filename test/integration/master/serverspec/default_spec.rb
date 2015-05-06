require_relative 'spec_helper'

describe file('/etc/apt/sources.list.d/mesosphere.list') do
  it { should be_file }
end

describe package('mesos') do
  it { should be_installed }
end
