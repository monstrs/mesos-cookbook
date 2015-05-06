require 'consul/client'
require 'spec_helper'

describe 'Mesos Cluster Services' do
  before do
    @client = Consul::Client.v1.http(host: get_node_config('discovery', 'hostname'))
  end

  it 'has zookeeper service' do
    expect(@client.get('/catalog/service/zookeeper').size).to eq 1
  end

  it 'has exhibitor service' do
    expect(@client.get('/catalog/service/exhibitor').size).to eq 1
  end

  it 'has etcd service' do
    expect(@client.get('/catalog/service/etcd').size).to eq 1
  end

  it 'has mesos-master service' do
    expect(@client.get('/catalog/service/mesos-master').size).to eq 1
  end

  it 'has kube-apiserver service' do
    expect(@client.get('/catalog/service/kube-apiserver').size).to eq 1
  end
end
