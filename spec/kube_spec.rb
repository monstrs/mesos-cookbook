require 'active_support/time'
require 'kubeclient'
require 'rspec/wait'
require 'spec_helper'

describe 'Kubernetes Mesos' do
  before :all do
    api_server = "http://#{get_node_config('kubernetes', 'hostname')}:8888/api/"
    @id = "nginx-#{SecureRandom.hex.slice(0..5)}"
    @client = Kubeclient::Client.new api_server, 'v1beta1'
  end

  let(:pod) do
    Kubeclient::Pod.new.tap do |pod|
      pod.metadata = {}
      pod.kind = 'Pod'
      pod.apiVersion = 'v1beta1'
      pod.id = @id
      pod.desiredState = {}
      pod.desiredState.manifest = {}
      pod.desiredState.manifest.version = 'v1beta1'
      pod.desiredState.manifest.containers = [{
        'name' => @id,
        'image' => 'library/nginx',
        'ports' => [{
          'containerPort' => 80,
          'name' => 'http'
        }]
      }]
      pod.labels = {}
      pod.labels.name = @id
    end
  end

  let(:service) do
    Kubeclient::Service.new.tap do |service|
      service.metadata = {}
      service.id = @id
      service.kind = 'Service'
      service.apiVersion = 'v1beta1'
      service.port = 8000
      service.containerPort = 'http'
      service.selector = {}
      service.selector.name = @id
    end
  end

  it 'create pod' do
    result = @client.create_pod pod
    expect(result.id).to eq @id
    expect(result.kind).to eq pod.kind
  end

  it 'create service' do
    result = @client.create_service service
    expect(result.id).to eq @id
    expect(result.kind).to eq service.kind
  end

  it 'check pod running' do
    wait(120.seconds, delay: 10.seconds).for { @client.get_pod(@id).currentState.status }.to eq 'Running'
  end

  it 'load balancer proxy pod endpoints' do
    wait(120.seconds, delay: 10.seconds).for { get_endpoint(@id) }.to include('Welcome to nginx')
  end
end
